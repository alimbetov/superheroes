
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/alignment_Info.dart';

part 'biography.g.dart';

@JsonSerializable()
class  Biography {

  final String alignment;
  final String fullName;
  final List<String> aliases;
  final String placeOfBirth;

  Biography( {required this.fullName,required this.alignment,required this.aliases, required this.placeOfBirth,});

  factory Biography.fromJson(final Map <String,dynamic> json) => _$BiographyFromJson(json);

  Map<String,dynamic> toJson() => _$BiographyToJson(this);

  AlignmentInfo? get alignmentInfo => AlignmentInfo.fromAlignment(alignment);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Biography &&
          runtimeType == other.runtimeType &&
          alignment == other.alignment &&
          fullName == other.fullName &&
          ListEquality<String>().equals (aliases , other.aliases) &&
          placeOfBirth == other.placeOfBirth;

  @override
  int get hashCode =>
      alignment.hashCode ^
      fullName.hashCode ^
      aliases.hashCode ^
      placeOfBirth.hashCode;

  @override
  String toString() {
    return 'Biography{alignment: $alignment, fullName: $fullName, aliases: $aliases, placeOfBirth: $placeOfBirth}';
  }
}
