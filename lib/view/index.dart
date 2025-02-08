import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:recipe_dictionary/view/fav.dart';
import 'package:recipe_dictionary/view/homepage.dart';

import '../helpers/colorshelper.dart';
import '../helpers/fonthelper.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  List<Widget> children = [
    const HomePage(),
    const FavoritePage(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorHelper.primaryColor,
        selectedLabelStyle: FontHelper.getHeading6(color: Colors.white),
        unselectedLabelStyle: FontHelper.getHeading6(color: Colors.white),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.star),
            label: 'Favorites',
          ),
        ],
        currentIndex: index,
        selectedItemColor: ColorHelper.white,
        unselectedItemColor: ColorHelper.black,
        onTap: (int d) {
          setState(() {
            index = d;
          });
        },
      ),
      body: children[index],
    );
  }
}
