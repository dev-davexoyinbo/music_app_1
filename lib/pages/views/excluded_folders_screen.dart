import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';

class ExcludedFoldersScreen extends StatelessWidget {
  ExcludedFoldersScreen({Key? key}) : super(key: key);

  final TextStyle titleTextStyle = TextStyle(color: Colors.grey[100]);
  final TextStyle subtitleTextStyle = TextStyle(color: Colors.grey[500]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.darkColor,
        appBar: AppBar(
          backgroundColor: MyTheme.darkColor,
          elevation: 2,
          shadowColor: MyTheme.accentColor,
          title: Text("Excluded Folders"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            ListTile(
              title: Text("Downloads", style: titleTextStyle),
              subtitle: Text("//adfa/a//", style: subtitleTextStyle),
              leading: Icon(Icons.folder, color: Colors.grey[100], size: 40),
              trailing: Icon(Icons.close, color: Colors.grey[400]),
            )
          ],
        ),
      ),
    );
  }
}
