
import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/power_stats.dart';
import 'package:superheroes/model/serverImage.dart';

part 'superhero.g.dart';

@JsonSerializable()
class  SuperHero  {

  final String id;
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;

  SuperHero({ required this.name, required this.biography,required  this.image, required this.powerstats, required this.id});

  factory SuperHero.fromJson(final Map <String,dynamic> json) => _$SuperHeroFromJson(json);

  bool  isNotNull () =>
       this.powerstats.combat!="null"
    && this.powerstats.durability!="null"
    && this.powerstats.intelligence!="null"
    && this.powerstats.power!="null"
    && this.powerstats.speed!="null"
    && this.powerstats.strength!="null";

  Map<String,dynamic> toJson() => _$SuperHeroToJson(this);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperHero &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          biography == other.biography &&
          image == other.image &&
          powerstats == other.powerstats;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      biography.hashCode ^
      image.hashCode ^
      powerstats.hashCode;

  @override
  String toString() {
    return 'SuperHero{id: $id, name: $name, biography: $biography, image: $image, powerstats: $powerstats}';
  }
}
