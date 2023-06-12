import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exeption/apiExeption.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperHeroBloc {
  http.Client? client;

  final String id;

  final superHeroSubject = BehaviorSubject<SuperHero>();

  Stream<SuperHero> observeSuperHero() => superHeroSubject;

  StreamSubscription? requestSubsription;

  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;
  StreamSubscription? getFromFavoriteSubscription;

  SuperHeroBloc({required this.id, required this.client}) {
    requestSuperHero();
  }


  void getFromFavorites(){
    getFromFavoriteSubscription?.cancel();
    getFromFavoriteSubscription=FavoriteSuperHeroStorage.getInstance()
        .getSuperHero(id)
        .asStream()
        .listen((superHero) {
          if (superHero!= null){
            superHeroSubject.add(superHero);
          }
           requestSuperHero();
    }, onError: (error, stackTrace) {
      print("Error happened in getFromFavorites  error=$error  , stackTrace=$stackTrace");
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
      print("Error happened in addToFavorite  error=$error  , stackTrace=$stackTrace");
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
      print("Error happened in removeFromFavorite  error=$error  , stackTrace=$stackTrace");
    });

  }

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperHeroStorage.getInstance().observeIsFavorite(id);

  void requestSuperHero() {
    requestSubsription?.cancel();
    requestSubsription = request().asStream().listen((superHero) {
      if (superHero != null) {
        superHeroSubject.add(superHero);
      }
    }, onError: (error, stackTrace) {
      print("requestSuperHeroInfo  error=$error  , stackTrace=$stackTrace");
    });
  }

  Future<SuperHero> request() async {
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
        return SuperHero.fromJson(decode);
      }
      throw Exception('Unknown error happened');
    }
    throw Exception('Unknown error happened');
  }

  void dispose() {
    client?.close();
    superHeroSubject.close();
    requestSubsription?.cancel();

    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    getFromFavoriteSubscription?.cancel();
  }
}
