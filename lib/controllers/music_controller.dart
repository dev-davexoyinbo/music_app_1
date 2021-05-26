import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicController extends GetxController{
  final songs = <SongModel>[].obs;

  Future<bool> requestPermission() async {
    bool val = await OnAudioQuery().permissionsRequest();

    return Future.value(val);
  }

  Future<bool> getSongs() async{
    print("Getting all songs from device storage");
    await requestPermission();
    List<SongModel> songs = await OnAudioQuery().querySongs();
    print("Count: ${songs.length}");

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
}//end class MusicController