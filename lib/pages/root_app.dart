import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:project_manga/json/root_app_json.dart';
import 'package:project_manga/pages/home_page.dart';
import 'package:project_manga/pages/anime_page.dart';
import 'package:project_manga/pages/favorite_manga_page.dart';
import 'package:project_manga/pages/other_page.dart';


class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: getTabs(),
      body: getBody(),
    );
  }
  Widget getBody(){
    return IndexedStack(
      index: pageIndex,
      children: [
        HomePage(),
        AnimeListPage(),
        FavoriteAnimePage(),
        OtherPage(),
      ],
    );
  }

  Widget getTabs() {
    return SalomonBottomBar(
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        items: List.generate(rootAppJson.length, (index) {
          return SalomonBottomBarItem(
              selectedColor: rootAppJson[index]['color'],
              icon: Icon(rootAppJson[index]['icon']),
              title: Text(rootAppJson[index]['text']));
        }));
  }
}
