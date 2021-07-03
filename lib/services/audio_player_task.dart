import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';
import 'package:collection/collection.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  static const String UPDATE_QUEUE = "UPDATE_QUEUE";
  static const String STOP_SONG = "STOP_SONG";

  final AudioPlayer _audioPlayer = AudioPlayer();
  late StreamSubscription<dynamic> _onPlaySubscription;

  List<MediaItem> get _queue => AudioServiceBackground.queue ?? <MediaItem>[];

  bool get hasNext {
    MediaItem? currentItem = AudioServiceBackground.mediaItem;

    if (currentItem == null) {
      return false;
    }

    int index = _queue.indexWhere((element) => element.id == currentItem.id);

    if (index >= _queue.length - 1) {
      return false;
    }

    return true;
  }

  bool get _playing {
    return _audioPlayer.state == PlayerState.PLAYING;
  }

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("Audio service started");
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      _setState(position: duration);
    });

    _onPlaySubscription =
        _audioPlayer.onPlayerCompletion.listen(_onCompletionListener);

    _setState();
  }

  @override
  Future<void> onStop() async {
    await _onPlaySubscription.cancel();
    await _audioPlayer.stop();
    await _audioPlayer.release();
    return await super.onStop();
  } //end method onStart

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
      case STOP_SONG:
        print("Stopping song");
        await _audioPlayer.stop();
        await _setState();
        break;
    } //end switch case
  } //end method onCustomAction

  void _onCompletionListener(_) {
    MediaItem currentMediaItem = AudioServiceBackground.mediaItem as MediaItem;

    var stopTheCurrentSong = () {
      _setState();
    };

    switch (AudioServiceBackground.state.repeatMode) {
      // AudioServiceRepeatMode { none, one, all, group }
      case AudioServiceRepeatMode.none:
        if (hasNext)
          onSkipToNext();
        else
          stopTheCurrentSong();
        break;
      case AudioServiceRepeatMode.group:
        if (hasNext)
          onSkipToNext();
        else
          stopTheCurrentSong();
        break;
      case AudioServiceRepeatMode.all:
        if (hasNext) {
          onSkipToNext();
        } else if (_queue.length > 0) {
          onPlayFromMediaId(_queue[0].id);
        } else {
          stopTheCurrentSong();
        }
        break;
      case AudioServiceRepeatMode.one:
        onPlayFromMediaId(currentMediaItem.id);
        break;
    }
  } //end method _onCompletionListener

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

    await _audioPlayer.resume();
    _setState(processingState: AudioProcessingState.none);
  }

  @override
  Future<void> onPause() async {
    await _audioPlayer.pause();
    _setState();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await _audioPlayer.seek(position);
  } //end method onSeekTo

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async {
    await _setState(repeatMode: repeatMode);
  } //end method onSetRepeatMode

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (AudioServiceBackground.queue != null) {
      if (shuffleMode != AudioServiceShuffleMode.none) {
        AudioServiceBackground.queue!.shuffle();
      } else {
        AudioServiceBackground.queue!
            .sort((a, b) => a.title.toString().compareTo(b.title.toString()));
      }

      _updateQueue(AudioServiceBackground.queue!);
    }

    await _setState(shuffleMode: shuffleMode);
  } //end method onSetShuffleMode

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    MediaItem? mediaItem =
        _queue.firstWhereOrNull((element) => element.id == mediaId);

    if (mediaItem == null) return;

    int result =
        await _audioPlayer.play(_getMediaPlayPath(mediaItem), isLocal: true);

    if (result == 1) {
      AudioServiceBackground.setMediaItem(mediaItem);
    }

    _setState();
  } //end method onPlayFromMediaId

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    return onPlayFromMediaId(mediaId);
  } // end method onPlay

  Future<void> _setState(
      {AudioProcessingState? processingState,
      Duration? position,
      AudioServiceRepeatMode? repeatMode,
      AudioServiceShuffleMode? shuffleMode}) async {
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState: processingState ?? AudioProcessingState.none,
      playing: _playing,
      position: position,
      // speed,
      // updateTime,
      // androidCompactActions,
      repeatMode: repeatMode ?? AudioServiceBackground.state.repeatMode,
      shuffleMode: shuffleMode ?? AudioServiceBackground.state.shuffleMode,
    );
  } //end method _setState

  List<MediaControl> getControls() {
    List<MediaControl> controls = <MediaControl>[
      MediaControl.skipToPrevious,
      if (_playing) ...[MediaControl.pause] else ...[MediaControl.play],
      MediaControl.skipToNext,
      // else ...[MediaControl.stop],
    ];

    return controls;

    // if (_playing) {
    //   return [
    //     MediaControl.skipToPrevious,
    //     MediaControl.pause,
    //     MediaControl.skipToNext,
    //     MediaControl.stop,
    //   ];
    // } else {
    //   return [
    //     MediaControl.skipToPrevious,
    //     MediaControl.play,
    //     MediaControl.skipToNext,
    //     MediaControl.stop,
    //   ];
    // }
  } //end method getControls
} //end class AudioPlayerTask
