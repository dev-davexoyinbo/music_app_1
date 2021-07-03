import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/models/my_song_model.dart';
import 'package:music_app_trial_1/models/queue_type.dart';
import 'package:music_app_trial_1/models/repeat_type.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/services/audio_player_task.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:collection/collection.dart';

void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class MusicController extends GetxController {
  final songs = <SongModel>[].obs;
  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);

  // final AudioPlayer _audioPlayer = AudioPlayer();
  final isPlaying = false.obs;
  final currentPlayTime = Duration().obs;
  final currentMaxTime = Duration().obs;
  final _queue = <SongModel>[].obs;
  final _queueType = QueueType.NULL.obs;
  final _audioRepeatMode = AudioServiceRepeatMode.none.obs;
  final shuffle = false.obs;

  // new code
  final StreamController<List<SongModel>> _songsStreamController =
      StreamController<List<SongModel>>();
  late final Stream<List<SongModel>> _songsStream;

  RepeatType get repeatType {
    switch (_audioRepeatMode.value) {
      case AudioServiceRepeatMode.one:
        return RepeatType.REPEAT_ONE;
      case AudioServiceRepeatMode.all:
        return RepeatType.REPEAT_ALL;
      case AudioServiceRepeatMode.none:
        return RepeatType.NO_REPEAT;
      case AudioServiceRepeatMode.group:
        return RepeatType.REPEAT_ALL;
      default:
        return RepeatType.NO_REPEAT;
    }
  } //end get repeatType

  @override
  void onInit() async {
    super.onInit();
    // TODO:  find a better way to do this without broadcasting
    _songsStream =
        _songsStreamController.stream.asBroadcastStream(onListen: (_) {
      _songsStreamController.sink.add(this.songs);
    }).distinct();
    AudioService.currentMediaItemStream.listen(_currentMediaItemLister);
    AudioService.queueStream.listen(_queueListener);
    AudioService.positionStream.listen(_positionStreamListener);
    AudioService.playbackStateStream.listen(_playBackStateListener);

    await AudioService.connect();
    if (!AudioService.running) {
      var x = await AudioService.start(
        backgroundTaskEntrypoint: _entrypoint,
        androidNotificationChannelName: 'Humming Bird',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: MyTheme.darkColorBlur.value,
        androidShowNotificationBadge: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
      );
      print(x);
    } else {
      print("Audio service is running");
    }

    // await _getSongs();
    // await _updateQueue(songs.value);


    _getSongs()
    .then((songs) async{
      await _updateQueue(songs);
    });

    AudioService.setRepeatMode(
        AudioServiceRepeatMode.none); // none/one/all/group
    AudioService.setShuffleMode(AudioServiceShuffleMode.none); // none/all/group
  } // end method onInit

  void _playBackStateListener(PlaybackState state) {
    isPlaying.value = state.playing;

    _audioRepeatMode.value = state.repeatMode;
    shuffle.value = state.shuffleMode == AudioServiceShuffleMode.all;
  } //end method _playBackStateListener

  void _positionStreamListener(Duration duration) {
    currentPlayTime.value = duration;
  } //end method _positionStreamListener

  @override
  void onClose() {
    _songsStreamController.close();
    AudioService.disconnect();
  }

  void _currentMediaItemLister(MediaItem? mediaItem) {
    if (mediaItem == null) return;

    currentSong.value = songs.firstWhereOrNull(
        (SongModel element) => element.id.toString() == mediaItem.id);
    currentMaxTime.value = mediaItem.duration as Duration;
  } //end method _currentMediaItemLister

  void _queueListener(List<MediaItem>? mediaItems) {
    if (mediaItems == null) {
      _queue.value = [];
    }

    _queue.value = mediaItems
        !.map((mediaItem) => songs.firstWhereOrNull(
            (SongModel element) => element.id.toString() == mediaItem.id))
        .where((element) => element != null)
        .toList().cast<SongModel>();
    print("Queue updated in controller: ${_queue.length}");
  } //end method _queueListener

  Stream<List<SongModel>> getSongsStream() {
    return _songsStream;
  } //end method getSongsStream

  Future<List<SongModel>> _getSongs() async {
    print("Getting all songs from device storage");
    await _requestPermission();
    List<SongModel> songs = await OnAudioQuery().querySongs();

    this.songs.clear();
    this.songs.addAll(songs);

    _songsStreamController.sink.add(this.songs);

    return Future.value(this.songs);
  } //end method _getSongs

  Future<void> _updateQueue(List<SongModel> songModels) async {
    var mySongModels = songModels
        .map((songModel) =>
            json.encode(_convertSongModelToMySongModel(songModel).toJson()))
        .toList();

    await AudioService.customAction(
        AudioPlayerTask.UPDATE_QUEUE, {"data": mySongModels});
  } //end method _updateQueue

  MySongModel _convertSongModelToMySongModel(SongModel songModel) {
    return MySongModel(
        id: songModel.id.toString(),
        album: songModel.album,
        title: songModel.title,
        artist: songModel.artist,
        duration: songModel.duration.toString(),
        path: songModel.data);
  } //end method _convertSongModelToMediaItem

  Future<void> playSong(SongModel? song,
      {QueueType queueType = QueueType.SONG}) async {
    if (song == null) return;

    await _changeQueueType(queueType);

    await AudioService.playFromMediaId(song.id.toString());
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

  Future<void> pauseSong() async {
    return AudioService.pause();
  }

  Future<void> resumeSong() async {
    return AudioService.play();
  }

  Future<void> seek(Duration duration) async {
    await AudioService.seekTo(duration);
  } //end seek

  Future<void> _requestPermission() async {
    if (!(await OnAudioQuery().permissionsStatus()))
      await OnAudioQuery().permissionsRequest();
  }

  Future<ImageProvider> getAudioImage(SongModel? songModel, {int? size}) async {
    Uint8List? uint8list;
    if (songModel != null && songModel.artwork == null) {
      try{
        uint8list =
        await OnAudioQuery().queryArtworks(songModel.id, ArtworkType.AUDIO, ArtworkFormat.JPEG, size);
      }catch( error){
        print(error.toString());
      }
    }

    if(uint8list != null)
      return Future.value(MemoryImage(uint8list));
    return Future.value(placeholderImage());
  } //end method getAudioImage

  ImageProvider placeholderImage() {
    return AssetImage("assets/images/placeholder_image.jpg");
  }

  Future<void> toggleRepeat() async {
    print("toggle repeat");
    var repeatModes = [
      AudioServiceRepeatMode.none,
      AudioServiceRepeatMode.all,
      AudioServiceRepeatMode.one
    ];

    int newIndex =
        (repeatModes.indexOf(_audioRepeatMode.value) + 1) % repeatModes.length;

    await AudioService.setRepeatMode(repeatModes[newIndex]);
  } //end method toggleRepeat

  Future<void> stopSong() async {
    await AudioService.customAction(AudioPlayerTask.STOP_SONG);
  }//end method stopSong

  Future<void> clearSong() async {
    await stopSong();
    currentSong.value = null;
  }//end method clearSong

  Future<void> toggleShuffle() async {
    await AudioService.setShuffleMode(
        shuffle.value ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all);
  } //end method toggleShuffle
} //end class MusicController
