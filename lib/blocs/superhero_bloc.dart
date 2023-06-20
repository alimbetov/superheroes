import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exeption/apiExeption.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_Colors.dart';

class SuperHeroBloc {
  http.Client? client;

  final String id;

  final superHeroSubject = BehaviorSubject<SuperHero>();
  final superHeroPageStateSubject = BehaviorSubject<SuperheroPageState>();




  StreamSubscription? requestSubsription;

  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;
  StreamSubscription? getFromFavoriteSubscription;

  SuperHeroBloc({required this.id, required this.client}) {
    getFromFavorites();
  }

  void getFromFavorites() {
    getFromFavoriteSubscription?.cancel();
    getFromFavoriteSubscription = FavoriteSuperHeroStorage.getInstance()
        .getSuperHero(id)
        .asStream()
        .listen((superHero) {
      if (superHero != null) {
        superHeroSubject.add(superHero);
        superHeroPageStateSubject.add(SuperheroPageState.loaded);
      }else {
        superHeroPageStateSubject.add(SuperheroPageState.loading);
      }
      requestSuperHero(superHero != null);
    }, onError: (error, stackTrace) {
      print(
          "Error happened in getFromFavorites  error=$error  , stackTrace=$stackTrace");
    });
  }

  void addToFavorite() {
    final superHero = superHeroSubject.valueOrNull;
    if (superHero == null) {
      print("Error superhero is null");
      return;
    }
    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperHeroStorage.getInstance()
        .addToFavorites(superHero)
        .asStream()
        .listen((event) {
      print("Added to favorits $event");
    }, onError: (error, stackTrace) {
      print(
          "Error happened in addToFavorite  error=$error  , stackTrace=$stackTrace");
    });
  }

  void removeFromFavorite() {
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


  void requestSuperHero(final bool isInFavorites) {
    requestSubsription?.cancel();
    requestSubsription = request().asStream().listen((superHero) {
      if (superHero != null) {
        superHeroSubject.add(superHero);
        superHeroPageStateSubject.add(SuperheroPageState.loaded);
      }
    }, onError
        : (error, stackTrace) {
      if(!isInFavorites){
        superHeroPageStateSubject.add(SuperheroPageState.error);
      }
      print("requestSuperHeroInfo  error=$error  , stackTrace=$stackTrace");
    });
  }

  void retry( ){
    superHeroPageStateSubject.add(SuperheroPageState.loading);
    requestSuperHero(false);
  }

  Future<SuperHero> request() async {
    //await Future.delayed(Duration(seconds: 5));
    final token = dotenv.env["SUPERHERO_TOKEN"];
    final response = await (client ?? http.Client())
        .get(Uri.parse('https://superheroapi.com/api/${token}/$id'));
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    } else if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    } else if (response.statusCode == 200) {
      final decode = json.decode(response.body);
      if (decode['response'] == 'error') {
        if (decode['error'] == 'character with given name not found') {
          throw ApiException('Client error happened');
        } else {
          throw ApiException('Client error happened');
        }
      } else if (decode['response'] == 'success') {
        final superHeror = SuperHero.fromJson(decode);
        await FavoriteSuperHeroStorage.getInstance().updateifInFavorites(superHeror);
        return superHeror;
      }
      throw Exception('Unknown error happened');
    }
    throw Exception('Unknown error happened');
  }


  Stream<bool> observeIsFavorite() =>
      FavoriteSuperHeroStorage.getInstance().observeIsFavorite(id);

  Stream<SuperHero> observeSuperHero() => superHeroSubject.distinct();

  Stream<SuperheroPageState> observeSuperHeroPageState() => superHeroPageStateSubject.distinct();



  void dispose() {
    client?.close();
    superHeroSubject.close();
    superHeroPageStateSubject.close();
    requestSubsription?.cancel();

    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    getFromFavoriteSubscription?.cancel();
  }
}

enum SuperheroPageState {
  loading, loaded, error
  }