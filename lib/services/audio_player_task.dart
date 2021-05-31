import 'dart:collection';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  static const String UPDATE_QUEUE = "updateQueue";
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
        print("Background task : Updating queue");
        var arguments2 = arguments["data"] as List;
        List<MediaItem> mediaItems = arguments2
            .map((e) => _convertMySongModelToMediaItem(
                MySongModel.fromJson(json.decode(e))))
            .toList();
        _updateQueue(mediaItems);
        break;
    }//end switch case
  } //end method onCustomAction

  MediaItem _convertMySongModelToMediaItem(MySongModel model) {
    return MediaItem(
        id: model.id,
        album: model.album,
        title: model.title,
        artist: model.artist,
        duration: Duration(milliseconds: int.parse(model.duration)));
  } //end method _convertMySongModelToMediaItem

  void _updateQueue(List<MediaItem> mediaItems) {
    _queue = mediaItems;
  } //end method _updateQueue

} //end class AudioPlayerTask
