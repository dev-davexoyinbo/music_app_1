// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySongModel _$MySongModelFromJson(Map<String, dynamic> json) {
  return MySongModel(
    id: json['id'] as String,
    artist: json['artist'] as String,
    album: json['album'] as String,
    title: json['title'] as String,
    duration: json['duration'] as String,
    path: json['path'] as String,
  );
}

Map<String, dynamic> _$MySongModelToJson(MySongModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'album': instance.album,
      'title': instance.title,
      'artist': instance.artist,
      'duration': instance.duration,
      'path': instance.path,
    };
