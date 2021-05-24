import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: BottomNavigationBar(
          backgroundColor: MyTheme.darkColor,
          selectedItemColor: MyTheme.accentColor,
          unselectedItemColor: Colors.grey[300],
          iconSize: 20,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.featured_play_list_outlined),
                label: "Playlists"),
          ]),
    );
  }
}
