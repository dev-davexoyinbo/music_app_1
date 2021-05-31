import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';
import 'package:collection/collection.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  static const String UPDATE_QUEUE = "UPDATE_QUEUE";
  static const String PLAY_SONG_BY_ID = "PLAY_SONG";
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<MediaItem> _queue = <MediaItem>[];

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("Audio service started");
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    switch (name) {
      case UPDATE_QUEUE:
        var arguments2 = arguments["data"] as List;
        List<MediaItem> mediaItems = arguments2
            .map((e) => _convertMySongModelToMediaItem(
                MySongModel.fromJson(json.decode(e))))
            .toList();
        _updateQueue(mediaItems);
        break;
      case PLAY_SONG_BY_ID:
        _playSongById(arguments["data"] as String);
        break;
    } //end switch case
  } //end method onCustomAction

  MediaItem _convertMySongModelToMediaItem(MySongModel model) {
    return MediaItem(
      id: model.id,
      album: model.album,
      title: model.title,
      artist: model.artist,
      duration: Duration(
        milliseconds: int.parse(model.duration),
      ),
      extras: {"path" : model.path}
    );
  } //end method _convertMySongModelToMediaItem

  void _updateQueue(List<MediaItem> mediaItems) {
    _queue = mediaItems;
  } //end method _updateQueue

  Future<void> _playSongById(String id) async {
    MediaItem? mediaItem =
        _queue.firstWhereOrNull((element) => element.id == id);

    if (mediaItem == null) return;

    await AudioServiceBackground.setMediaItem(mediaItem);
    return AudioService.play();
  } //end method _playSong

  @override
  Future<void> onPlay() async {
    if (AudioServiceBackground.mediaItem == null) {
      if (_queue.length > 0)
        await AudioServiceBackground.setMediaItem(_queue.first);
      else
        return;
    }

    MediaItem mediaItem = AudioServiceBackground.mediaItem as MediaItem;

    _audioPlayer.play(_getMediaPlayPath(mediaItem), isLocal: true);
  } //end method onPlay

  String _getMediaPlayPath(MediaItem mediaItem) {
    if (mediaItem.extras == null) return "";

    return mediaItem.extras!["path"];
  } //end method _getMediaPlayPath

} //end class AudioPlayerTask
