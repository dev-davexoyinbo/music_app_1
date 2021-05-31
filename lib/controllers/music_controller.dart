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
  final Rx<SongModel?> currentSong = null.obs;
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
    await AudioService.start(backgroundTaskEntrypoint: _entrypoint);
    await _getSongs();
    await _updateQueue(songs.value);

    AudioService.currentMediaItemStream.listen(_currentMediaItemLister);

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
  }

  void _currentMediaItemLister(MediaItem? mediaItem) {
    if(mediaItem == null)
      return;

    currentSong.value = songs
        .firstWhereOrNull((SongModel element) => element.id == _currentSongId);
  }//end method _currentMediaItemLister

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

  Future<void> _updateQueue(List<SongModel> songModels)  async {
    var mySongModels = songModels
        .map((songModel) => json.encode(_convertSongModelToMySongModel(songModel).toJson()))
        .toList();

    await AudioService.customAction(AudioPlayerTask.UPDATE_QUEUE, {"data" : mySongModels});
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

  Future<bool> playSongById(int id) async {
    SongModel song =
        songs.firstWhere((SongModel songModel) => songModel.id == id);

    return playSong(song);
  }

  Future<bool> playSong(SongModel? song,
      {QueueType queueType = QueueType.SONG}) async {

    if (song == null) return Future.value(false);

    changeQueueType(queueType);

    if (_queue.firstWhereOrNull((SongModel element) => element.id == song.id) ==
        null) return Future.value(false);

    int success = await _audioPlayer.play(song.data, isLocal: true);
    if (success == 1) {
      this.isPlaying.value = true;
      this._currentSongId = song.id;

      update();
      return Future.value(true);
    }
    return Future.value(false);
  } //end class playSong

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

  Future<bool> skipToNext({bool onCompletion = false}) async {
    // If onCompletion and repeat is repeat one
    if (onCompletion && repeatType.value == RepeatType.REPEAT_ONE) {
      return playSong(currentSong.value);
    }

    SongModel? nextSong;

    if (currentSong == null) {
      if (_queue.length != 0) nextSong = _queue[0];
    } else {
      int index = _queue.indexWhere((song) => song.id == _currentSongId);
      int nextIndex;
      nextIndex = (index + 1);
      if (onCompletion &&
          repeatType.value == RepeatType.NO_REPEAT &&
          nextIndex >= _queue.length) {
        isPlaying.value = false;
        return Future.value(true);
      }

      nextIndex %= _queue.length;

      nextSong = _queue[nextIndex];
    }

    return playSong(nextSong);
  } //end method skipToNext

  Future<bool> skipToPrevious() async {
    SongModel? nextSong;

    if (currentSong == null) {
      if (_queue.length != 0) nextSong = _queue[0];
    } else {
      int index = _queue.indexWhere((song) => song.id == _currentSongId);
      int nextIndex = (index - 1);
      if (nextIndex < 0) {
        nextIndex = _queue.length + nextIndex;
      }
      nextSong = _queue[nextIndex];
    }

    return playSong(nextSong);
  }

  Future<bool> stopSong() async {
    await _audioPlayer.stop();

    this.isPlaying.value = false;

    return Future.value(true);
  }

  Future<bool> clearSong() async {
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

  Future<void> changeQueueType(QueueType queueType) async {
    if (_queueType.value == queueType) return;

    _queueType.value = queueType;

    switch (_queueType.value) {
      case QueueType.SONG:
        await _updateQueue(songs);
        break;
    }
  }

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
