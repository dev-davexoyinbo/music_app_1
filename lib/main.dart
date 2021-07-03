import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/exclude_folders_controller.dart';
import 'package:music_app_trial_1/controllers/exclude_folders_controller.dart';
import 'package:music_app_trial_1/controllers/home_controller.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/controllers/settings_controller.dart';
import 'package:music_app_trial_1/controllers/settings_controller.dart';
import 'package:music_app_trial_1/pages/views/excluded_folders_screen.dart';
import 'package:music_app_trial_1/pages/views/home_screen.dart';
import 'package:music_app_trial_1/pages/views/settings_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key){
    Get.lazyPut<MusicController>(() => MusicController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<ExcludeFolderController>(() => ExcludeFolderController());
    // Get.put(MusicController());
    // Get.put(MainController());
    // Get.put(HomeController());
  }// end constructor



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/settings", page: () => SettingsPage(), transition: Transition.zoom),
        GetPage(name: "/settings/excluded-folders", page: () => ExcludedFoldersScreen()),
      ],
      theme: ThemeData(
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,

        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home:  HomeScreen(),
    );
  } //end build method
} //end class MyApp
