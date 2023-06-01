

import 'package:json_annotation/json_annotation.dart';

part 'biography.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class  Biography {

  final String alignment;
  final String fullName;

  Biography(this.fullName, this.alignment);

  factory Biography.fromJson(final Map <String,dynamic> json) => _$BiographyFromJson(json);

  Map<String,dynamic> toJson() => _$BiographyToJson(this);

}