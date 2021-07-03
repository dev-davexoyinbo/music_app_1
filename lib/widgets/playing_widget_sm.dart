import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';

class PlayingWidgetSm extends StatelessWidget {
  PlayingWidgetSm({Key? key}) : super(key: key);

  final MainController mainController = Get.find<MainController>();
  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                mainController.displayMediaSheetAction(true);
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder<ImageProvider>(
                      future: musicController
                          .getAudioImage(musicController.currentSong.value),
                      builder: (context, snapshot) {
                        ImageProvider image =
                            musicController.placeholderImage();
                        if (snapshot.connectionState == ConnectionState.done &&
                            !snapshot.hasError) {
                          image = snapshot.data as ImageProvider;
                        }

                        return CircleAvatar(
                          backgroundImage: image,
                          radius: 22,
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                musicController.currentSong.value!.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          SizedBox(height: 3),
                          Obx(() => Text(
                                musicController.currentSong.value!.artist,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => GestureDetector(
                    onTap: () async {
                      if (musicController.isPlaying.value) {
                        await musicController.pauseSong();
                      } else {
                        await musicController.resumeSong();
                      }
                    },
                    child: Icon(
                        musicController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                        color: Colors.grey[200]),
                  )),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async{
                  await musicController.clearSong();
                },
                child: Icon(
                  Icons.clear_outlined,
                  size: 30,
                  color: Colors.grey[200],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
