import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';
import 'package:collection/collection.dart';

MediaControl playControl = MediaControl(
    androidIcon: 'drawable/play_arrow',
    label: 'Play',
    action: MediaAction.play);

MediaControl pauseControl = MediaControl(
    androidIcon: 'drawable/pause', label: 'Pause', action: MediaAction.pause);

MediaControl skipToNextControl = MediaControl(
    androidIcon: 'drawable/skip_to_next',
    label: 'Next',
    action: MediaAction.skipToPrevious);

MediaControl skipToPreviousControl = MediaControl(
    androidIcon: 'drawable/skip_to_prev',
    label: 'Previous',
    action: MediaAction.play);

MediaControl stopControl = MediaControl(
    androidIcon: 'drawable/stop', label: 'Stop', action: MediaAction.stop);

class AudioPlayerTask extends BackgroundAudioTask {
  static const String UPDATE_QUEUE = "UPDATE_QUEUE";
  static const String PLAY_SONG_BY_ID = "PLAY_SONG";

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<MediaItem> _queue = <MediaItem>[];
  AudioProcessingState _audioProcessingState = AudioProcessingState.none;
  bool _playing = false;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("Audio service started");
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      _setState(position: duration);
    });
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
        extras: {"path": model.path});
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

  String _getMediaPlayPath(MediaItem mediaItem) {
    if (mediaItem.extras == null) return "";

    return mediaItem.extras!["path"];
  } //end method _getMediaPlayPath

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
  } // end method onPlay

  @override
  Future<void> onSkipToNext() async {
    MediaItem? nextSong;

    if (AudioServiceBackground.mediaItem == null) {
      if (_queue.length != 0) nextSong = _queue[0];
    } else {
      var mediaItem = AudioServiceBackground.mediaItem as MediaItem;
      if (_queue.length == 0) {
        nextSong = null;
      } else {
        int index = _queue.indexWhere((song) => song.id == mediaItem.id);
        int nextIndex;
        nextIndex = (index + 1);
        nextIndex %= _queue.length;
        nextSong = _queue[nextIndex];
      }
    }

    if (nextSong == null) return;

    await AudioServiceBackground.setMediaItem(nextSong);
    return AudioService.play();
  }

  @override
  Future<void> onSkipToPrevious() async {
    MediaItem? nextSong;

    MediaItem? mediaItem = AudioServiceBackground.mediaItem;

    if (mediaItem == null) {
      if (_queue.length != 0) nextSong = _queue[0];
    } else {
      int index = _queue.indexWhere((song) => song.id == mediaItem.id);
      if (index == -1) {
        nextSong = _queue[0];
      } else {
        int nextIndex = (index - 1);
        if (nextIndex < 0) {
          nextIndex = _queue.length + nextIndex;
        }
        nextSong = _queue[nextIndex];
      }
    }

    if (nextSong == null) return;
    await AudioServiceBackground.setMediaItem(nextSong);
    return AudioService.play();
  } //end method onSkipToPrevious

  Future<void> _setState(
      { AudioProcessingState? processingState,
        Duration? position,
        Duration? bufferedPosition}) async {
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState: processingState ?? AudioServiceBackground.state.processingState,
      playing: _playing,
      position: position,
      // bufferedPosition,
      // speed,
      // updateTime,
      // androidCompactActions,
      // repeatMode,
      // shuffleMode,
    );
  }//end method _setState

List<MediaControl> getControls() {
    if(_playing){
      return [
        skipToPreviousControl,
        pauseControl,
        stopControl,
        skipToNextControl
      ];
    }else {
      return [
        skipToPreviousControl,
        playControl,
        stopControl,
        skipToNextControl
      ];
    }
}//end method getControls
} //end class AudioPlayerTask
