import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/home_controller.dart';
import 'package:music_app_trial_1/controllers/main_controller.dart';
import 'package:music_app_trial_1/controllers/music_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/widgets/music_detail_sheet.dart';
import 'package:music_app_trial_1/widgets/my_navbar.dart';
import 'package:music_app_trial_1/widgets/my_sliver_app_bar.dart';
import 'package:music_app_trial_1/widgets/tracks_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
} //end class HomeScreen

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MainController mainController = Get.find<MainController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: homeController.homeTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.darkColor,
      body: SizedBox.expand(
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, isScrolled) {
                return [
                  MySliverAppBar(
                      tabController: _tabController),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  TracksTab(),
                  Center(child: Text("Tab two"))
                ],
              ),
            ),
            Obx(
                () {
                  return AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: mainController.showMediaSheet.value ? 65 : MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 65,
                    child: MusicDetailSheet(),
                  );
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
          ()  => Visibility(
            visible: !mainController.showMediaSheet.value,
            maintainAnimation: true,
            maintainState: true,
            child: MyNavBar(),
          )
      )
    );
  } //end build method

} //end state class
