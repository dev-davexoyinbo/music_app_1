import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';

class TrackStrip extends StatefulWidget {
  final String name;
  final String artist;
  final String timeString;
  late final bool isPlaying;
  final Future<ImageProvider> imageFuture;

  TrackStrip({
    Key? key,
    required this.name,
    required this.artist,
    required this.timeString,
    bool? isPlaying,
    required this.imageFuture,
  }) : super(key: key) {
    this.isPlaying = isPlaying ?? false;
  }

  @override
  _TrackStripState createState() => _TrackStripState();
}

class _TrackStripState extends State<TrackStrip> {
  final MusicController musicController = Get.find<MusicController>();
  @override
  Widget build(BuildContext context) {
    Color lightColor =
        widget.isPlaying ? MyTheme.accentColor : Colors.grey[200] as Color;
    Color fadedColor = widget.isPlaying
        ? MyTheme.accentColor.withAlpha(200)
        : Colors.grey[400] as Color;

    return Container(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                FutureBuilder<ImageProvider>(
                  future: widget.imageFuture,
                  builder: (context, snapshot) {
                    ImageProvider image = musicController.placeholderImage();
                    if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
                      image = snapshot.data as ImageProvider;
                    }

                    return CircleAvatar(
                      backgroundImage: image,
                      radius: 28,
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
                      Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        textWidthBasis: TextWidthBasis.parent,
                        softWrap: false,
                        style: TextStyle(
                          color: lightColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.artist,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: fadedColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
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
              Text(
                widget.timeString,
                style: TextStyle(
                    color: fadedColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    fontFeatures: [FontFeature.tabularFigures()]),
              ),
            ],
          )
        ],
      ),
    );
  }
} //end class TrackStrip
