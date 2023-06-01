import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:superheroes/resources/super_heroes_images.dart';

class MainBloc {
  static const MinSymbols = 3;

  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();

  final favoriteSuperHeroSDubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.moked);

  final searchSuperHeroSDubject = BehaviorSubject<List<SuperheroInfo>>();

  final currentTextSubject = BehaviorSubject<String>.seeded("");

  StreamSubscription? textSubscription;

  StreamSubscription? searchSubscription;

  StreamSubscription<MainPageState>? streamSubscription;

  MainBloc() {
    stateSubject.add(MainPageState.noFavorites);

/*
    textSubscription
    = currentTextSubject.distinct().debounceTime(Duration(milliseconds: 500)).listen((value) {
*/

    textSubscription
      =Rx.combineLatest2<String,List<SuperheroInfo>,MainStatePageInfo>
    (currentTextSubject.distinct().debounceTime(Duration(milliseconds: 500))
        , favoriteSuperHeroSDubject, (searchText, favorites) => MainStatePageInfo(
              searchText: searchText, hasFavorites: favorites.isNotEmpty,)).listen((value) {
        print("changed ${value}" );
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {

        if (value.hasFavorites){
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
      stateSubject.add(MainPageState.loadingError);
    });
  }

  Stream<List<SuperheroInfo>> observFavoriteSuperHeroes()=> favoriteSuperHeroSDubject;
  Stream<List<SuperheroInfo>> observSearchedSuperHeroes()=> searchSuperHeroSDubject;




  Future<List<SuperheroInfo>> search(String text) async {
    await Future.delayed(Duration(seconds: 1));

    return SuperheroInfo.moked
        .where((superheroInfo) => superheroInfo.name.toLowerCase().contains(text.toLowerCase()))
        .toList();

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

  void removeFavorite(){
    List<SuperheroInfo> currentList = favoriteSuperHeroSDubject.value;
    if(currentList.isEmpty){
      favoriteSuperHeroSDubject.add(SuperheroInfo.moked);
    } else {
      favoriteSuperHeroSDubject.add(currentList.sublist(0, currentList.length-1)) ;
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


class MainStatePageInfo{

final String searchText;
final bool hasFavorites;

const MainStatePageInfo({ required this.searchText, required this.hasFavorites});

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