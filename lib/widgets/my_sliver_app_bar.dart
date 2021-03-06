import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app_trial_1/controllers/home_controller.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/pages/views/settings_page.dart';

class MySliverAppBar extends StatefulWidget {
  late final TabController _tabController;

  MySliverAppBar({Key? key, required TabController tabController})
      : super(key: key) {
    this._tabController = tabController;
  }

  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyTheme.darkColor,
      elevation: 2,
      expandedHeight: 56 * 2 + 190,
      pinned: true,
      // floating: true,
      // snap: true,
      collapsedHeight: 56,
      shadowColor: Colors.white.withAlpha(70),
      leading: GestureDetector(
        child: Icon(
          Icons.polymer,
          color: MyTheme.accentColor,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Icon(Icons.search),
        ),
        Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.toNamed("/settings");
                // print("Going to the settings page");
              },
              child: Icon(Icons.manage_accounts_outlined)),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: EdgeInsets.only(bottom: 56),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50.0),
                child: Text(
                  "Find the best music for your banger",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: MyTheme.darkColorLight,
                  // focusColor: Colors.red,
                  // border: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.white),
                  //   borderRadius: BorderRadius.circular(100),
                  // )
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.accentColor)),
                  // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: TabBar(
        controller: widget._tabController,
        indicatorColor: MyTheme.accentColor,
        tabs: homeController.homeTabs,
      ),
    );
  }
}
