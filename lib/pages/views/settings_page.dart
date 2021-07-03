import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/my_theme.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final TextStyle titleTextStyle = TextStyle(color: Colors.grey[100]);
  final TextStyle subtitleTextStyle = TextStyle(color: Colors.grey[500]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.darkColor,
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: MyTheme.darkColor,
          elevation: 2,
          shadowColor: MyTheme.accentColor,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _headingText("General Settings"),
            ListTile(
              onTap: () {
                Get.toNamed("/settings/excluded-folders");
              },
              title: Text(
                "Excluded Folders",
                style: titleTextStyle,
              ),
              subtitle: Text(
                "Get the list of folders to exclude",
                style: subtitleTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  } //end method build

  Widget _headingText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          color: MyTheme.accentColor,
        ),
      ),
    );
  }//end method _headingText
} //end class SettingsPage
