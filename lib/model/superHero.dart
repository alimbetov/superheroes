
import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/power_stats.dart';
import 'package:superheroes/model/serverImage.dart';

part 'superHero.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class  SuperHero  {
  final String id;
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;

  SuperHero({ required this.name, required this.biography,required  this.image, required this.powerstats, required this.id});




  factory SuperHero.fromJson(final Map <String,dynamic> json) => _$SuperHeroFromJson(json);

  Map<String,dynamic> toJson() => _$SuperHeroToJson(this);

}



/*class SuperHero {
  final String name;
  final Biography biography;
  final ServerImage image;

  SuperHero(this.name, this.biography, this.image);

  factory SuperHero.fromJson(final Map<String, dynamic> json) => SuperHero(
        json['name'],
        Biography.fromJson(json['biography']),
        ServerImage.fromJson(json['image']),
      );

  Map<String, dynamic> toJson() =>
      {"name": name, "biography": biography.toJson(), "image": image.toJson()};
}*/
