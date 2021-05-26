import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/models/queue_type.dart';
import 'package:music_app_trial_1/models/repeat_type.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:collection/collection.dart';

class MusicController extends GetxController {
  final songs = <SongModel>[].obs;
  int _currentSongId = -1.obs;
  late AudioPlayer _audioPlayer;
  final isPlaying = false.obs;
  final currentPlayTime = Duration().obs;
  final currentMaxTime = Duration().obs;
  final _queue = <SongModel>[].obs;
  final _queueType = QueueType.SONG.obs;
  final repeatType = RepeatType.NO_REPEAT.obs;

  MusicController() {
    _audioPlayer = AudioPlayer();
  }

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      currentPlayTime.value = duration;
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      currentMaxTime.value = duration;
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      skipToNext(onCompletion: true);
    });
  }

  @override
  void onClose() {
    _audioPlayer.release();
  }

  SongModel? get currentSong {
    return songs
        .firstWhereOrNull((SongModel element) => element.id == _currentSongId);
  }

  Future<bool> requestPermission() async {
    bool val = false;
    if (!(await OnAudioQuery().permissionsStatus()))
      val = await OnAudioQuery().permissionsRequest();

    return Future.value(val);
  }

  Future<bool> getSongs() async {
    print("Getting all songs from device storage");
    await requestPermission();
    List<SongModel> songs = await OnAudioQuery().querySongs();

    this.songs.removeRange(0, this.songs.length);
    this.songs.addAll(songs);

    return Future.value(true);
  } //end method getArtists2

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

  Future<bool> playSong(SongModel? song, {QueueType? queueType}) async {
    if (song == null) return Future.value(false);

    changeQueueType(queueType ?? QueueType.SONG);

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
      return playSong(currentSong);
    }

    SongModel? nextSong;

    if (currentSong == null) {
      if (_queue.length != 0) nextSong = _queue[0];
    } else {
      int index = _queue.indexOf(currentSong);
      int nextIndex;
      nextIndex = (index + 1);
      if(onCompletion && repeatType.value == RepeatType.NO_REPEAT){
        isPlaying.value = false;
        return Future.value(true);
      }


      nextIndex %= _queue.length;

      nextSong = _queue[nextIndex];
    }

    return playSong(nextSong);
  }

  Future<bool> skipToPrevious() async {
    SongModel? nextSong;

    if (currentSong == null) {
      if (_queue.length != 0) nextSong = _queue[0];
    } else {
      int index = _queue.indexOf(currentSong);
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

  void changeQueueType(QueueType queueType) {
    // if(_queueType.value == queueType)
    //   return;

    _queueType.value = queueType;

    switch (_queueType.value) {
      case QueueType.SONG:
        _queue.removeRange(0, _queue.length);
        _queue.addAll(songs);
        break;
    }
  }

  void toggleRepeat() {
    var repeatTypes = RepeatType.values;
    int newIndex =
        (repeatTypes.indexOf(repeatType.value) + 1) % repeatTypes.length;

    repeatType.value = repeatTypes[newIndex];
    print(repeatType.value);
  }
} //end class MusicController
