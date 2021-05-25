import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/widgets/my_bottom_navigation_bar.dart';
import 'package:music_app_trial_1/widgets/playing_widget_sm.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({Key? key}) : super(key: key);

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PlayingWidgetSm(),
          ),
          MyBottomNavigationBar(),
        ],
      ),
    );
  } //end method build

} //end state class
