import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/widgets/my_bottom_navigation_bar.dart';
import 'package:music_app_trial_1/widgets/playing_widget_sm.dart';

class MyNavBar extends StatelessWidget {
  MyNavBar({Key? key}) : super(key: key);

  final MusicController musicController = Get.find<MusicController>();
  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: MyTheme.darkColorBlur,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Visibility(
                visible: musicController.currentSong.value != null,
                child: GestureDetector(
                  onVerticalDragEnd: (DragEndDetails details){
                    if((details.primaryVelocity ?? 0 ) < -8)
                      mainController.displayMediaSheetAction(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PlayingWidgetSm(),
                  ),
                ),
              )),
          MyBottomNavigationBar(),
        ],
      ),
    );
  } //end method build

} //end state class
