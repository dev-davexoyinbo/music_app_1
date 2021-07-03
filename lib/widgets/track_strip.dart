import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';

class TrackStrip extends StatelessWidget {
  final String name;
  final String artist;
  final String timeString;
  final Future<ImageProvider> imageFuture;
  final int id;

  TrackStrip({
    Key? key,
    required this.name,
    required this.artist,
    required this.timeString,
    required this.id,
    required this.imageFuture,
  }) : super(key: key);

  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                FutureBuilder<ImageProvider>(
                  future: imageFuture,
                  builder: (context, snapshot) {
                    ImageProvider image = musicController.placeholderImage();
                    if (snapshot.connectionState == ConnectionState.done &&
                        !snapshot.hasError) {
                      image = snapshot.data as ImageProvider;
                    }

                    return CircleAvatar(
                      backgroundImage: image,
                      radius: 25,
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
                          name,
                          overflow: TextOverflow.ellipsis,
                          textWidthBasis: TextWidthBasis.parent,
                          softWrap: false,
                          style: TextStyle(
                            color: musicController.currentSong.value != null && musicController.currentSong.value!.id == id
                                ? MyTheme.accentColor
                                : Colors.grey[200] as Color,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Obx(() => Text(
                          artist,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: musicController.currentSong.value != null && musicController.currentSong.value!.id == id
                                ? MyTheme.accentColor.withAlpha(200)
                                : Colors.grey[400] as Color,
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Row(
            children: [
              Obx(() => Text(
                  timeString,
                  style: TextStyle(
                      color: musicController.currentSong.value != null && musicController.currentSong.value!.id == id
                          ? MyTheme.accentColor.withAlpha(200)
                          : Colors.grey[400] as Color,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      fontFeatures: [FontFeature.tabularFigures()]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
} //end class TrackStrip
