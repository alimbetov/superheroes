import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exeption/apiExeption.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/alignment_Info.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:http/http.dart' as http;

class MainBloc {
  static const MinSymbols = 3;

  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();

/*
  final favoriteSuperHeroSDubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.moked);
*/

  final searchSuperHeroSDubject = BehaviorSubject<List<SuperheroInfo>>();
  final currentTextSubject = BehaviorSubject<String>.seeded("");
  StreamSubscription? textSubscription;

  StreamSubscription? searchSubscription;
  StreamSubscription? removeFromFavoriteSubscription;
  http.Client? client;

  StreamSubscription<MainPageState>? streamSubscription;

  MainBloc({this.client}) {
    //stateSubject.add(MainPageState.noFavorites);
    textSubscription = Rx.combineLatest2<String, List<SuperHero>,
            MainStatePageInfo>(
        currentTextSubject.distinct().debounceTime(Duration(milliseconds: 500)),
        FavoriteSuperHeroStorage.getInstance().observeFavoriteSuperHeroes(),
        (searchText, favorites) => MainStatePageInfo(
              searchText: searchText,
              hasFavorites: favorites.isNotEmpty,
            )).listen((value) {
      print("changed ${value}");
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {
        if (value.hasFavorites) {
          stateSubject.add(MainPageState.favorites);
        } else {
          stateSubject.add(MainPageState.noFavorites);
        }
      } else if (value.searchText.length < 3) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        searchForSuperHeroes(value.searchText);
      }
    });
  }

  void searchForSuperHeroes(final String text) {
    //todo
    stateSubject.add(MainPageState.loading);
    searchSubscription = search(text).asStream().listen((searchResult) {
      if (searchResult.isEmpty) {
        stateSubject.add(MainPageState.nothingFound);
      } else {
        stateSubject.add(MainPageState.searchResult);
        searchSuperHeroSDubject.add(searchResult);
      }
    }, onError: (error, stackTrace) {
      print(error);
      stateSubject.add(MainPageState.loadingError);
    });
  }

  void retry() {
    final curText = currentTextSubject.value;
    searchForSuperHeroes(curText);
  }

  Stream<List<SuperheroInfo>> observFavoriteSuperHeroes() {
    return FavoriteSuperHeroStorage.getInstance()
        .observeFavoriteSuperHeroes()
        .map((superHeroes) => superHeroes
            .map((superHero) => SuperheroInfo.fromSuperHero(superHero))
            .toList());
  }

  Stream<List<SuperheroInfo>> observSearchedSuperHeroes() =>
      searchSuperHeroSDubject;

  Future<List<SuperheroInfo>> search(String text) async {
    final token = dotenv.env["SUPERHERO_TOKEN"];

    final response = await (client ?? http.Client())
        .get(Uri.parse('https://superheroapi.com/api/${token}/search/${text}'));

    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    } else if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    } else if (response.statusCode == 200) {
      final decode = json.decode(response.body);

      if (decode['response'] == 'error') {
        if (decode['error'] == 'character with given name not found') {
          return [];
        } else {
          throw ApiException('Client error happened');
        }
      } else if (decode['response'] == 'success') {
        final List<dynamic> results = decode['results'];
        List<SuperHero> superheroes =
            results.map((e) => SuperHero.fromJson(e)).toList();

        List<SuperheroInfo> found = superheroes.map((superhero) {
          return SuperheroInfo.fromSuperHero(superhero);
        }).toList();

        return found;
      }

      throw Exception('Unknown error happened');
    }
    throw Exception('Unknown error happened');
  }

  Stream<MainPageState> observeMainPageState() => stateSubject;

/*  {
return Stream.periodic(Duration(seconds: 2), (tick) => tick )
.map((tick) => MainPageState.values[(tick % MainPageState.values.length )]);
  }*/

  void nextState() {
    print("TAP");
    final currentState = stateSubject.value;
    final nextState = MainPageState.values[
        (MainPageState.values.indexOf(currentState) + 1) %
            MainPageState.values.length];

    stateSubject.add(nextState);
  }

  void updateText(final String? text) {
    currentTextSubject.add(text ?? "");
  }

  void removeFromFavortes(final String id) {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperHeroStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen((event) {
      print("removeFromFavorite from favorits $event");
    }, onError: (error, stackTrace) {
      print(
          "Error happened in removeFromFavorite  error=$error  , stackTrace=$stackTrace");
    });
  }

  void dispose() {
    stateSubject?.close();
    streamSubscription?.cancel();
    searchSuperHeroSDubject?.close();
    searchSubscription?.cancel();
    currentTextSubject?.close();
    textSubscription?.cancel();
    client?.close();
    removeFromFavoriteSubscription?.cancel();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResult,
  favorites,
}

class SuperheroInfo {
  final String id;
  final String name;
  final String realName;
  final String imageUrl;
  final AlignmentInfo? alignmentInfo;

  @override
  String toString() {
    return 'SuperheroInfo{name: $name, realName: $realName, imageUrl: $imageUrl}';
  }

  factory SuperheroInfo.fromSuperHero(final SuperHero superHero) {
    return SuperheroInfo(
        id: superHero.id,
        name: superHero.name,
        realName: superHero.biography.fullName,
        imageUrl: superHero.image.url,
        alignmentInfo: superHero.biography.alignmentInfo);
  }

  const SuperheroInfo(
      {required this.id,
      required this.name,
      required this.realName,
      required this.imageUrl,
      this.alignmentInfo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperheroInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          realName == other.realName &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;

  static const moked = [
    SuperheroInfo(
        id: "70",
        name: "BATMAN",
        realName: "Bruce Wayne",
        imageUrl: SuperHeroesImages.batmanUrl),
    SuperheroInfo(
        id: "732",
        name: "IRONMAN",
        realName: "Tony Stark",
        imageUrl: SuperHeroesImages.ironmanUrl),
    SuperheroInfo(
        id: "687",
        name: "VENOM",
        realName: "Eddie Brock",
        imageUrl: SuperHeroesImages.venomUrl),
  ];
}

class MainStatePageInfo {
  final String searchText;
  final bool hasFavorites;

  const MainStatePageInfo(
      {required this.searchText, required this.hasFavorites});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainStatePageInfo &&
          runtimeType == other.runtimeType &&
          searchText == other.searchText &&
          hasFavorites == other.hasFavorites;

  @override
  int get hashCode => searchText.hashCode ^ hasFavorites.hashCode;

  @override
  String toString() {
    return 'MainStatePageInfo{searchText: $searchText, hasFavorites: $hasFavorites}';
  }
}
