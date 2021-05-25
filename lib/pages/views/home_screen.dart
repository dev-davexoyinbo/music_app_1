import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Tab> _myTabs = [
    Tab(text: "Tracks"),
    Tab(text: "Albums"),
  ];
  bool showMediaSheet = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);
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
              // physics: BouncingScrollPhysics(),
              headerSliverBuilder: (context, isScrolled) {
                return [
                  MySliverAppBar(
                      tabController: _tabController, myTabs: _myTabs),
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
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: showMediaSheet ? 65 : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 65,
              child: MusicDetailSheet(
                displayMediaSheetAction: _displayMediaSheetAction,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !this.showMediaSheet,
        maintainAnimation: true,
        maintainState: true,
        child: MyNavBar(displayMediaSheetAction: _displayMediaSheetAction),
      ),
    );
  } //end build method

  void _displayMediaSheetAction(bool showMediaSheet) {
    setState(() {
      this.showMediaSheet = !this.showMediaSheet;
    });
  } //end method _displayMediaSheet
} //end state class
