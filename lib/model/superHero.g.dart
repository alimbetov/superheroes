// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superHero.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperHero _$SuperHeroFromJson(Map<String, dynamic> json) => SuperHero(
      name: json['name'] as String,
      biography: Biography.fromJson(json['biography'] as Map<String, dynamic>),
      image: ServerImage.fromJson(json['image'] as Map<String, dynamic>),
      powerstats:
          Powerstats.fromJson(json['powerstats'] as Map<String, dynamic>),
      id: json['id'] as String,
    );

Map<String, dynamic> _$SuperHeroToJson(SuperHero instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'biography': instance.biography.toJson(),
      'image': instance.image.toJson(),
      'powerstats': instance.powerstats.toJson(),
    };
