import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/widgets/music_detail_sheet.dart';
import 'package:music_app_trial_1/widgets/my_sliver_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
} //end class HomeScreen

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> _myTabs = [
    Tab(text: "Commercial"),
    Tab(text: "Free license"),
  ];

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
                  MySliverAppBar(tabController: _tabController, myTabs: _myTabs,),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Text("Tab one"),
                  ),
                  Center(
                    child: Text("Tab two")
                  )
                ],
              ),
            ),
            SizedBox.expand(
              child: MusicDetailSheet(),
            )
          ],
        ),
      )
    );
  } //end build method

  Widget _renderDummyList() {
    return ListView.builder(itemBuilder: (_, index) {
      return Container(
        child: Text("List ${index + 1}")
      );
    });
  }
} //end state class
