import 'package:json_annotation/json_annotation.dart';

part 'serverImage.g.dart';

@JsonSerializable()
class  ServerImage  {

  final String url;

  factory ServerImage.fromJson(final Map <String,dynamic> json) => _$ServerImageFromJson(json);

  ServerImage(this.url);

  Map<String,dynamic> toJson() => _$ServerImageToJson(this);

}



/*
class ServerImage {
final String url;
ServerImage(this.url);

factory ServerImage.fromJson(final Map <String,dynamic> json)
=> ServerImage( json["url"]);

Map<String,dynamic> toJson() => { "url":url };

}*/
