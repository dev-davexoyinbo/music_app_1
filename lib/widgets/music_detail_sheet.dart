import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/models/repeat_type.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/utils/my_time_utils.dart';

class MusicDetailSheet extends StatelessWidget {
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
              behavior: HitTestBehavior.opaque,
              onTap: () {
                mainController.displayMediaSheetAction(false);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyTheme.darkColorBlur,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.grey[300],
                  size: 38,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // child: QueryArtworkWidget(
              //   id: musicController.currentSong.value!.id,
              //   type: ArtworkType.AUDIO,
              //   artwork: musicController.currentSong.value!.artwork,
              //   deviceInfo: await OnAudioQuery().queryDeviceInfo(),
              // ),
              child: Obx(
                () => FutureBuilder<ImageProvider>(
                  future: musicController.getAudioImage(musicController.currentSong.value),
                  builder: (context, snapshot) {
                    if ((snapshot.connectionState == ConnectionState.done)) {
                      return Container(
                        // height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: snapshot.data as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        // height: 320,
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
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 340,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            musicController.currentSong.value != null
                                ? musicController.currentSong.value!.title
                                : "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
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
                  Obx(
                    () => Text(
                      musicController.currentSong.value != null
                          ? musicController.currentSong.value!.artist
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
                    child: Obx(() {
                      int intMax =
                          musicController.currentMaxTime.value.inMilliseconds;

                      int intVal =
                          musicController.currentPlayTime.value.inMilliseconds;

                      if (intMax > 0) intVal %= intMax;

                      double value = intVal.toDouble();
                      double max = intMax.toDouble();

                      return Slider(
                          value: value,
                          onChanged: (value) async {
                            await musicController
                                .seek(Duration(milliseconds: value.toInt()));
                          },
                          label: MyTimeUtils.convertDurationToTimeString(
                              musicController.currentPlayTime.value),
                          min: 0,
                          max: max,
                          activeColor: Colors.grey[300],
                          inactiveColor: Colors.grey[700]);
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        int max =
                            musicController.currentMaxTime.value.inMilliseconds;
                        int value = musicController
                            .currentPlayTime.value.inMilliseconds;

                        if (max > 0) value %= max;
                        return Text(
                          MyTimeUtils.convertDurationToTimeString(
                              Duration(milliseconds: value)),
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.white,
                              fontFeatures: [FontFeature.tabularFigures()]),
                        );
                      }),
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
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        IconData icon;
                        Color? color;
                        switch (musicController.repeatType) {
                          case RepeatType.NO_REPEAT:
                            icon = Icons.repeat;
                            color = Colors.grey[500];
                            break;
                          case RepeatType.REPEAT_ALL:
                            icon = Icons.repeat;
                            color = Colors.grey[200];
                            break;
                          case RepeatType.REPEAT_ONE:
                            icon = Icons.repeat_one_outlined;
                            color = Colors.grey[200];
                            break;
                        }

                        return IconButton(
                            onPressed: () {
                              musicController.toggleRepeat();
                            },
                            icon: Icon(
                              icon,
                              color: color,
                            ));
                      }),
                      Center(
                        child: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                musicController.skipToPrevious();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: MyTheme.darkColorBlur,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: (Colors.grey[200] as Color)
                                        .withOpacity(0.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (Colors.grey[200] as Color)
                                          .withOpacity(0.6),
                                      blurRadius: 2,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Icon(Icons.skip_previous,
                                      // color: MyTheme.darkColorBlur,
                                      color: Colors.grey[200]),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (musicController.isPlaying.value) {
                                  await musicController.pauseSong();
                                } else {
                                  await musicController.resumeSong();
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: MyTheme.darkColorBlur,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: (Colors.grey[200] as Color)
                                          .withOpacity(0.5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (Colors.grey[200] as Color)
                                          .withOpacity(0.6),
                                      blurRadius: 2,
                                    )
                                  ],
                                ),
                                child: Obx(
                                  () => Center(
                                    child: Icon(
                                      musicController.isPlaying.value
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      // color: MyTheme.darkColorBlur,
                                      color: Colors.grey[200],
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                musicController.skipToNext();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    // color: Colors.grey[200],
                                    color: MyTheme.darkColorBlur,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: (Colors.grey[200] as Color)
                                            .withOpacity(0.5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (Colors.grey[200] as Color)
                                            .withOpacity(0.6),
                                        blurRadius: 2,
                                      )
                                    ]),
                                child: Center(
                                  child: Icon(
                                    Icons.skip_next,
                                    // color: MyTheme.darkColorBlur,
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => IconButton(
                          onPressed: () {
                            musicController.toggleShuffle();
                          },
                          icon: Icon(
                            Icons.shuffle,
                            color: Colors.grey[
                                musicController.shuffle.value ? 200 : 500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
