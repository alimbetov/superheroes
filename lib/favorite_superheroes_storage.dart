import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/model/superhero.dart';

class FavoriteSuperHeroStorage {
  static const _key = "favorite_superheroes";

  final updater = PublishSubject<Null>();

  static FavoriteSuperHeroStorage? _instance;
  factory FavoriteSuperHeroStorage.getInstance() =>
        _instance?? FavoriteSuperHeroStorage._internal();
  FavoriteSuperHeroStorage. _internal();



  Future<bool> addToFavorites(SuperHero superHero) async {
    final rawSuperHeroes = await _getRawSuperHeroes();
    rawSuperHeroes.add(json.encode(superHero.toJson()));
    return _setRawSuperHeroes(rawSuperHeroes);
  }

  Future<bool> removeFromFavorites(final String id) async {
    final superheroes = await _getSuperHeroes();
    superheroes.removeWhere((superHero) => superHero.id == id);
    return _setSuperHeroes(superheroes);
  }


  Future<List<String>> _getRawSuperHeroes() async {
    final sp = await SharedPreferences.getInstance();
    final rawSuperHeroes = sp.getStringList(_key) ?? [];
    return rawSuperHeroes;
  }
  Future<bool> _setRawSuperHeroes(List<String> superheroes) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(_key, superheroes);
    updater.add(null);
    return result;
  }

  Future<List<SuperHero>> _getSuperHeroes() async {
    final rawSuperHeroes = await _getRawSuperHeroes();
    return rawSuperHeroes
        .map((rawSuperHero) => SuperHero.fromJson(json.decode(rawSuperHero)))
        .toList();
  }


  Future<bool> _setSuperHeroes(List<SuperHero> superheroes) async {
    final rawSuperHeroes = superheroes
        .map((superHero) => json.encode(superHero.toJson()))
        .toList();
    return _setRawSuperHeroes(rawSuperHeroes);
  }

  Future<SuperHero?> getSuperHero(final String id)  async{
    final superHeroes = await _getSuperHeroes();
    for(final superhero in superHeroes){
      if (superhero.id==id){
        return superhero;
      }
    }
    return null;
  }

  Stream<List<SuperHero>> observeFavoriteSuperHeroes()  async* {
    yield  await _getSuperHeroes();
    await for (final _ in updater){
      yield  await _getSuperHeroes();
    }
  }

  Stream<bool> observeIsFavorite(final String id) {
    return observeFavoriteSuperHeroes()
        .map((superHero) => superHero.any((superHero) => superHero.id==id));
  }
}
