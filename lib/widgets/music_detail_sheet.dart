import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/utils/my_time_utils.dart';

class MusicDetailSheet extends StatefulWidget {
  const MusicDetailSheet({
    Key? key,
  }) : super(key: key);

  @override
  _MusicDetailSheetState createState() => _MusicDetailSheetState();
}

class _MusicDetailSheetState extends State<MusicDetailSheet> {
  final MainController mainController = Get.find<MainController>();
  final MusicController musicController = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.darkColorBlur,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        // controller: scrollController,
        // padding: EdgeInsets.zero,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 16, bottom: 4),
            child: GestureDetector(
              onTap: () {
                mainController.displayMediaSheetAction(false);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: MyTheme.darkColorBlur,
                  size: 38,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<ImageProvider>(
              future:
                  musicController.getAudioImage(musicController.currentSong),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // ImageProvider image = musicController.placeholderImage();
                  // if (!snapshot.hasError) {
                  //   image = snapshot.data as ImageProvider;
                  // }
                  return Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: snapshot.data as ImageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 320,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: MyTheme.accentColor,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<MusicController>(
                      builder: (_) => Text(
                        musicController.currentSong != null
                            ? musicController.currentSong!.title
                            : "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border_outlined,
                            color: MyTheme.darkColorLight2),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.tune_outlined,
                            color: MyTheme.darkColorLight2),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 7),
                GetBuilder<MusicController>(
                  builder: (_) => Text(
                    musicController.currentSong != null
                        ? musicController.currentSong!.artist
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: MyTheme.darkColorLight2),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    trackShape: _CustomTrackShape(),
                  ),
                  child: Obx(
                    () => Slider(
                        value: musicController
                            .currentPlayTime.value.inMilliseconds
                            .toDouble(),
                        onChanged: (value) async{
                          await musicController.seek(Duration(milliseconds: value.toInt()));
                        },
                        label: MyTimeUtils.convertDurationToTimeString(
                            musicController.currentPlayTime.value),
                        min: 0,
                        max: musicController.currentMaxTime.value.inMilliseconds
                            .toDouble(),
                        activeColor: Colors.grey[300],
                        inactiveColor: Colors.grey[700]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        MyTimeUtils.convertDurationToTimeString(
                            musicController.currentPlayTime.value),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.white,
                            fontFeatures: [FontFeature.tabularFigures()]),
                      ),
                    ),
                    Obx(
                      () => Text(
                        MyTimeUtils.convertDurationToTimeString(
                            musicController.currentMaxTime.value),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.grey[400],
                            fontFeatures: [FontFeature.tabularFigures()]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.repeat,
                      color: Colors.grey[500],
                    ),
                    Center(
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.skip_previous,
                                color: MyTheme.darkColorBlur,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Obx(
                              () => GestureDetector(
                                onTap: () async {
                                  if (musicController.isPlaying.value) {
                                    await musicController.pauseSong();
                                  } else {
                                    await musicController.resumeSong();
                                  }
                                },
                                child: Center(
                                  child: Icon(
                                    musicController.isPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: MyTheme.darkColorBlur,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.skip_next,
                                color: MyTheme.darkColorBlur,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.shuffle,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } //end build t

} //end state class

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
