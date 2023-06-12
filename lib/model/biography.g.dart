// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biography _$BiographyFromJson(Map<String, dynamic> json) => Biography(
      fullName: json['full-name'] as String,
      alignment: json['alignment'] as String,
      aliases:
          (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
      placeOfBirth: json['place-of-birth'] as String,
    );

Map<String, dynamic> _$BiographyToJson(Biography instance) => <String, dynamic>{
      'alignment': instance.alignment,
      'full-name': instance.fullName,
      'aliases': instance.aliases,
      'place-of-birth': instance.placeOfBirth,
    };
