import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/home_controller.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/pages/views/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key){
    Get.lazyPut<MusicController>(() => MusicController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    // Get.put(MusicController());
    // Get.put(MainController());
    // Get.put(HomeController());

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
