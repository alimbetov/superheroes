// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superHero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperHero _$SuperHeroFromJson(Map<String, dynamic> json) => SuperHero(
      json['name'] as String,
      Biography.fromJson(json['biography'] as Map<String, dynamic>),
      ServerImage.fromJson(json['image'] as Map<String, dynamic>),
      Powerstats.fromJson(json['powerstats'] as Map<String, dynamic>),
      json['id'] as String,
    );

Map<String, dynamic> _$SuperHeroToJson(SuperHero instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'biography': instance.biography.toJson(),
      'image': instance.image.toJson(),
      'powerstats': instance.powerstats.toJson(),
    };
