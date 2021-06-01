import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';
import 'package:collection/collection.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  static const String UPDATE_QUEUE = "UPDATE_QUEUE";

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _playing = false;

  List<MediaItem> get _queue => AudioServiceBackground.queue ?? <MediaItem>[];

  bool get hasNext {
    MediaItem? currentItem = AudioServiceBackground.mediaItem;

    if(currentItem == null){
      return false;
    }

    int index = _queue.indexWhere(
        (element) => element.id == currentItem.id);

    if(index >= _queue.length) {
      return false;
    }

    return true;
  }

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("Audio service started");
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      _setState(position: duration);
    });

    _audioPlayer.onPlayerCompletion.listen(_onCompletionListener);
    _audioPlayer.onAudioPositionChanged.listen(_onAudioPositionChangedListener);

    _setState();
  }//end method onStart

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
    } //end switch case
  } //end method onCustomAction

  void _onCompletionListener(_) {
    MediaItem currentMediaItem = AudioServiceBackground.mediaItem as MediaItem;

    var stopTheCurrentSong = () {
      _playing = false;
      _setState();
    };

    switch (AudioServiceBackground.state.repeatMode) {
      // AudioServiceRepeatMode { none, one, all, group }
      case AudioServiceRepeatMode.none:
        if(hasNext) onSkipToNext();
        else stopTheCurrentSong();
        break;
      case AudioServiceRepeatMode.group:
        if(hasNext) onSkipToNext();
        else stopTheCurrentSong();
        break;
      case AudioServiceRepeatMode.all:
        if(hasNext) onSkipToNext();
        else if(_queue.length > 0) onPlayFromMediaId(_queue[0].id);
        else stopTheCurrentSong();
        break;
      case AudioServiceRepeatMode.one:
        onPlayFromMediaId(currentMediaItem.id);
        break;
    }
  } //end method _onCompletionListener

  void _onAudioPositionChangedListener(Duration duration) {
    _setState(position: duration);
  }// end method _onDurationChangedListener

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
    print("Updating queue");
    // _queue = mediaItems;
    AudioServiceBackground.setQueue(mediaItems);
  } //end method _updateQueue

  String _getMediaPlayPath(MediaItem mediaItem) {
    if (mediaItem.extras == null) return "";

    return mediaItem.extras!["path"];
  } //end method _getMediaPlayPath

  @override
  Future<void> onPlay() async {
    if (AudioServiceBackground.mediaItem == null) {
      if (_queue.length > 0) {
        await AudioServiceBackground.setMediaItem(_queue.first);
        return onSkipToQueueItem(AudioServiceBackground.mediaItem!.id);
      } else
        return;
    }

    _audioPlayer.resume();
    _playing = true;
    _setState(processingState: AudioProcessingState.none);
  }

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    MediaItem? mediaItem =
        _queue.firstWhereOrNull((element) => element.id == mediaId);

    if (mediaItem == null) return;

    int result =
        await _audioPlayer.play(_getMediaPlayPath(mediaItem), isLocal: true);

    if (result == 1) {
      AudioServiceBackground.setMediaItem(mediaItem);
      _playing = true;
      _setState();
    } else {
      _playing = false;
      _setState();
    }
  } //end method onPlayFromMediaId

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    return onPlayFromMediaId(mediaId);
  } // end method onPlay

  Future<void> _setState(
      {AudioProcessingState? processingState, Duration? position}) async {
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState: processingState ?? AudioProcessingState.none,
      playing: _playing,
      position: position,
      // speed,
      // updateTime,
      // androidCompactActions,
      // repeatMode,
      // shuffleMode,
    );
  } //end method _setState

  List<MediaControl> getControls() {
    if (_playing) {
      return [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
        MediaControl.stop,

      ];
    } else {
      return [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,

      ];
    }
  } //end method getControls
} //end class AudioPlayerTask
