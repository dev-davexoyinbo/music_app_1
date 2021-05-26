import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicController extends GetxController{
  final songs = <SongModel>[].obs;

  final _audioPlayer = AudioPlayer();

  Future<bool> requestPermission() async {
    bool val = await OnAudioQuery().permissionsRequest();

    return Future.value(val);
  }

  Future<bool> getSongs() async{
    print("Getting all songs from device storage");
    await requestPermission();
    List<SongModel> songs = await OnAudioQuery().querySongs();

    this.songs.removeRange(0, this.songs.length);
    songs.forEach((SongModel songModel) {
      this.songs.add(songModel);
    });


    return Future.value(true);
  }//end method getArtists2

  Future<ImageProvider> getAudioImage(SongModel songModel)  async {
    if(songModel.artwork == null) {
      var uint8list = await OnAudioQuery().queryArtworks(songModel.id, ArtworkType.AUDIO);
      if(uint8list == null){
        return Future.value(placeholderImage());
      }else {
        return Future.value(MemoryImage(uint8list));
      }

    }
    return Future.value(placeholderImage());
  }//end method getAudioImage


  ImageProvider placeholderImage() {
    return AssetImage("assets/images/placeholder_image.jpg");
  }

  Future<bool> playSongById(int id) async {
    SongModel song = songs.firstWhere((SongModel songModel) => songModel.id == id);

    return playSong(song);
  }

  Future<bool> playSong(SongModel song) async {
    print("Playing: ${song.data}");
    await _audioPlayer.play(song.data, isLocal: true);
    return Future.value(true);
  }//end class playSong
}//end class MusicController