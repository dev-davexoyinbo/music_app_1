import 'package:json_annotation/json_annotation.dart';
part 'my_song_model.g.dart';

@JsonSerializable()
class MySongModel {
  String id;
  String album;
  String title;
  String artist;

  //duration in milliseconds
  String duration;
  String path;

  MySongModel(
      {required this.id,
      required this.artist,
      required this.album,
      required this.title,
      required this.duration,
      required this.path});

  factory MySongModel.fromJson(Map<String, dynamic> json) => _$MySongModelFromJson(json);
  Map<String, dynamic> toJson() => _$MySongModelToJson(this);
} //end class MySongModel
