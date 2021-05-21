import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: MyTheme.darkColor,
            elevation: 5,
            expandedHeight: 56 * 2 + 180,
            pinned: true,
            collapsedHeight: 56,
            shadowColor: Colors.white.withAlpha(70),
            leading: Icon(
              Icons.polymer,
              color: MyTheme.accentColor,
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                child: Icon(Icons.search),
              ),
              Stack(alignment: AlignmentDirectional.center, children: [
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    // padding: EdgeInsets.all(6),
                    height: 20,
                    width: 20,
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: MyTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ]),
            ],
            floating: true,
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
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
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
                          borderSide: BorderSide(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.accentColor)
                        ),
                        // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: MyTheme.accentColor,
              tabs: _myTabs,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                      child: Text("List ${index + 1}"),
                    ),
                childCount: 200),
          ),
          // TabBarView(
          //   controller: _tabController,
          //   children: [
          //     // Container(
          //     //   child: _renderDummyList()
          //     // ),
          //     Center(
          //       child: Text("This is the second tab"),
          //     ),
          //     Center(
          //       child: Text("This is the first tab"),
          //     ),
          //   ],
          // )
        ],
      ),
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
