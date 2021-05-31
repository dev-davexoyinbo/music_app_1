import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';
import 'package:music_app_trial_1/models/queue_type.dart';
import 'package:music_app_trial_1/models/repeat_type.dart';
import 'package:music_app_trial_1/services/audio_player_task.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:collection/collection.dart';

void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class MusicController extends GetxController {
  final songs = <SongModel>[].obs;
  int _currentSongId = -1.obs;
  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  final AudioPlayer _audioPlayer = AudioPlayer();
  final isPlaying = false.obs;
  final currentPlayTime = Duration().obs;
  final currentMaxTime = Duration().obs;
  final _queue = <SongModel>[].obs;
  final _queueType = QueueType.NULL.obs;
  final repeatType = RepeatType.NO_REPEAT.obs;
  final shuffle = false.obs;

  // new code
  final StreamController<List<SongModel>> _songsStreamController =
      StreamController<List<SongModel>>();
  late final Stream<List<SongModel>> _songsStream;

  @override
  void onInit() async {
    super.onInit();
    _songsStream = _songsStreamController.stream.distinct();
    await AudioService.connect();
    if(!AudioService.running){
      var x = await AudioService.start(
        backgroundTaskEntrypoint: _entrypoint,
        androidNotificationChannelName: 'Audio Service Demo',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
      );
      print(x);
    }else {
      print("Audio service is running");
    }

    await _getSongs();
    await _updateQueue(songs.value);
    AudioService.currentMediaItemStream.listen(_currentMediaItemLister);

    // initialize current song
    // _currentMediaItemLister(AudioServiceBackground.mediaItem);

    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      currentPlayTime.value = duration;
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      currentMaxTime.value = duration;
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      skipToNext(onCompletion: true);
    });
  } // end method onInit

  @override
  void onClose() {
    _audioPlayer.release();
    _songsStreamController.close();
    AudioService.disconnect();
  }

  void _currentMediaItemLister(MediaItem? mediaItem) {
    if (mediaItem == null) return;

    currentSong.value = songs.firstWhereOrNull(
        (SongModel element) => element.id.toString() == mediaItem.id);
  } //end method _currentMediaItemLister

  Stream<List<SongModel>> getSongsStream() {
    return _songsStream;
  } //end method getSongsStream

  Future<void> _getSongs() async {
    print("Getting all songs from device storage");
    await _requestPermission();
    List<SongModel> songs = await OnAudioQuery().querySongs();

    this.songs.clear();
    this.songs.addAll(songs);

    _songsStreamController.sink.add(this.songs);
  } //end method _getSongs

  Future<void> _updateQueue(List<SongModel> songModels) async {
    var mySongModels = songModels
        .map((songModel) =>
            json.encode(_convertSongModelToMySongModel(songModel).toJson()))
        .toList();

    await AudioService.customAction(
        AudioPlayerTask.UPDATE_QUEUE, {"data": mySongModels});
    _queue.clear();
    _queue.addAll(songModels);
  } //end method _updateQueue

  MySongModel _convertSongModelToMySongModel(SongModel songModel) {
    return MySongModel(
        id: songModel.id.toString(),
        album: songModel.album,
        title: songModel.title,
        artist: songModel.artist,
        duration: songModel.duration,
        path: songModel.data);
  } //end method _convertSongModelToMediaItem

  Future<void> playSong(SongModel? song,
      {QueueType queueType = QueueType.SONG}) async {
    if (song == null) return;

    await _changeQueueType(queueType);

    await AudioService.customAction(
        AudioPlayerTask.PLAY_SONG_BY_ID, {"data": song.id.toString()});
  } //end class playSong

  Future<void> _changeQueueType(QueueType queueType) async {
    if (_queueType.value == queueType) return;

    _queueType.value = queueType;

    switch (_queueType.value) {
      case QueueType.SONG:
        await _updateQueue(songs);
        break;
    }
  }

  Future<void> skipToNext({bool onCompletion = false}) async {
    return AudioService.skipToNext();
  } //end method skipToNext

  Future<void> skipToPrevious() async {
    return AudioService.skipToPrevious();
  } //end method skipToPrevious

  // old code
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////

  Future<void> _requestPermission() async {
    if (!(await OnAudioQuery().permissionsStatus()))
      await OnAudioQuery().permissionsRequest();
  }

  Future<ImageProvider> getAudioImage(SongModel? songModel) async {
    if (songModel != null && songModel.artwork == null) {
      var uint8list =
          await OnAudioQuery().queryArtworks(songModel.id, ArtworkType.AUDIO);
      if (uint8list == null) {
        return Future.value(placeholderImage());
      } else {
        return Future.value(MemoryImage(uint8list));
      }
    }
    return Future.value(placeholderImage());
  } //end method getAudioImage

  ImageProvider placeholderImage() {
    return AssetImage("assets/images/placeholder_image.jpg");
  }

  Future<bool> pauseSong() async {
    await _audioPlayer.pause();

    this.isPlaying.value = false;

    return Future.value(true);
  }

  Future<bool> resumeSong() async {
    await _audioPlayer.resume();

    this.isPlaying.value = true;

    return Future.value(true);
  }

  Future<void> stopSong() async {
    await _audioPlayer.stop();

    this.isPlaying.value = false;

    return Future.value(true);
  }

  Future<void> clearSong() async {
    await stopSong();
    this._currentSongId = -1;

    update();

    return Future.value(true);
  }

  Future<bool> seek(Duration duration) async {
    _audioPlayer.seek(Duration(
        milliseconds:
            duration.inMilliseconds > currentMaxTime.value.inMilliseconds
                ? currentMaxTime.value.inMilliseconds
                : duration.inMilliseconds));
    return Future.value(true);
  } //end seek

  void toggleRepeat() {
    var repeatTypes = RepeatType.values;
    int newIndex =
        (repeatTypes.indexOf(repeatType.value) + 1) % repeatTypes.length;

    repeatType.value = repeatTypes[newIndex];
  }

  void toggleShuffle() {
    shuffle.value = !shuffle.value;
    if (shuffle.value) {
      _queue.shuffle();
    } else {
      _queue.sort((song1, song2) =>
          song1.title.toLowerCase().compareTo(song2.title.toLowerCase()));
    }
  }
} //end class MusicController
