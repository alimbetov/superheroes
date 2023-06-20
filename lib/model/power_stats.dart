import 'package:json_annotation/json_annotation.dart';

part 'power_stats.g.dart';

@JsonSerializable()
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;


  Powerstats({ required this.intelligence,required this.strength,required this.speed,required this.durability,
    required this.power,required this.combat});

  factory Powerstats.fromJson(final Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);

  double  convertStrinToPersent(String value) {
    final initValue = int.tryParse(value);
    if (initValue == null) return 0;
    return initValue / 100;
  }

  double get intelligencePercent => convertStrinToPersent(intelligence);
  double get strengthPercent => convertStrinToPersent(strength);
  double get speedPercent => convertStrinToPersent(speed);
  double get durabilityPercent => convertStrinToPersent(durability);
  double get powerPercent => convertStrinToPersent(power);
  double get combatPercent => convertStrinToPersent(combat);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Powerstats &&
          runtimeType == other.runtimeType &&
          intelligence == other.intelligence &&
          strength == other.strength &&
          speed == other.speed &&
          durability == other.durability &&
          power == other.power &&
          combat == other.combat;

  @override
  int get hashCode =>
      intelligence.hashCode ^
      strength.hashCode ^
      speed.hashCode ^
      durability.hashCode ^
      power.hashCode ^
      combat.hashCode;

  @override
  String toString() {
    return 'Powerstats{intelligence: $intelligence, strength: $strength, speed: $speed, durability: $durability, power: $power, combat: $combat}';
  }
}
