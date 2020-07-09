


import 'package:flutter/material.dart';
import 'package:flutter_app_demo/src/image/image.dart';
import 'package:flutter_app_demo/src/values/color.dart';
import 'package:flutter_app_demo/src/values/myweight.dart';
import 'package:flutter_app_demo/src/values/string.dart';

class MyHomePage extends StatefulWidget {



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  /**
   * 去布置作业
   */
  void toLayoutHomework() {}

  List<BottomNavigationBarItem> _listBottoms = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Image(
        image: MyImages.homeUnselect,
      ),
      activeIcon: Image(
        image: MyImages.homeSelect,
      ),
      title: Text(
        '首页',
      ),
    ),
    BottomNavigationBarItem(
      icon: Image(
        image: MyImages.examUnselect,
      ),
      activeIcon: Image(
        image: MyImages.examSelect,
      ),
      title: Text(
        '卷库',
      ),
    ),
    BottomNavigationBarItem(
      icon: Image(
        image: MyImages.personalCenterUnselect,
      ),
      activeIcon: Image(
        image: MyImages.personalCenterSelect,
      ),
      title: Text(
        '我的',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.1,
        backgroundColor: MyColors.colorBgAppBarPriamry,
        centerTitle: true,
        title: Text(
          MyStrings.app_name,
          style: TextStyle(fontWeight: MyWeights.TitleWeight,color: MyColors.colorTitleAppBarPrimary),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.colorBgbtnPrimaryPositive,
        onPressed: toLayoutHomework,
        tooltip: '进入布置作业',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor:  MyColors.colorTextMiddle,
        selectedItemColor: MyColors.colorTextPrimaryFirst,
        currentIndex: currentIndex,
        items: _listBottoms,
        onTap: onTap,
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
  }
}