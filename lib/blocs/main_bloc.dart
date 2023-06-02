import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exeption/apiExeption.dart';
import 'package:superheroes/model/superHero.dart';
import 'package:superheroes/resources/super_heroes_images.dart';
import 'package:http/http.dart' as http;

class MainBloc {
  static const MinSymbols = 3;

  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();

  final favoriteSuperHeroSDubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.moked);

  final searchSuperHeroSDubject = BehaviorSubject<List<SuperheroInfo>>();

  final currentTextSubject = BehaviorSubject<String>.seeded("");

  StreamSubscription? textSubscription;

  StreamSubscription? searchSubscription;

  http.Client? client;

  StreamSubscription<MainPageState>? streamSubscription;

  MainBloc({this.client}) {
    stateSubject.add(MainPageState.noFavorites);

/*
    textSubscription
    = currentTextSubject.distinct().debounceTime(Duration(milliseconds: 500)).listen((value) {
*/

    textSubscription = Rx.combineLatest2<String, List<SuperheroInfo>,
            MainStatePageInfo>(
        currentTextSubject.distinct().debounceTime(Duration(milliseconds: 500)),
        favoriteSuperHeroSDubject,
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

  Stream<List<SuperheroInfo>> observFavoriteSuperHeroes() =>
      favoriteSuperHeroSDubject;

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
          return SuperheroInfo(
              name: superhero.name,
              realName: superhero.biography.fullName,
              imageUrl: superhero.image.url);
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

  void removeFavorite() {
    List<SuperheroInfo> currentList = favoriteSuperHeroSDubject.value;
    if (currentList.isEmpty) {
      favoriteSuperHeroSDubject.add(SuperheroInfo.moked);
    } else {
      favoriteSuperHeroSDubject
          .add(currentList.sublist(0, currentList.length - 1));
    }

    print("remove Fav");
  }

  void dispose() {
    stateSubject?.close();
    streamSubscription?.cancel();
    searchSuperHeroSDubject?.close();
    currentTextSubject?.close();
    favoriteSuperHeroSDubject?.close();
    textSubscription?.cancel();
    client?.close();
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
  final String name;
  final String realName;
  final String imageUrl;

  @override
  String toString() {
    return 'SuperheroInfo{name: $name, realName: $realName, imageUrl: $imageUrl}';
  }

  const SuperheroInfo(
      {required this.name, required this.realName, required this.imageUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperheroInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          realName == other.realName &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;

  static const moked = [
    SuperheroInfo(
        name: "BATMAN",
        realName: "Bruce Wayne",
        imageUrl: SuperHeroesImages.batmanUrl),
    SuperheroInfo(
        name: "IRONMAN",
        realName: "Tony Stark",
        imageUrl: SuperHeroesImages.ironmanUrl),
    SuperheroInfo(
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
