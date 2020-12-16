import 'package:coffee_app/ui/profile.dart';
import 'package:flutter/material.dart';
import 'menu.dart';
import 'news_feed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  //ListData listData;
  final List<Widget> _pageWidgets = <Widget>[
    NewsFeedPage(),
    MenuPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pageWidgets),
      bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, 
       currentIndex: currentIndex,
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.home),
           label: 'Home',
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.menu),
           label: 'Menu',
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.person),
           label: 'Profile',
         )
       ],
     ),
    );
  }

  void onTabTapped(int index) {
   setState(() {
     currentIndex = index;
   });
 }
}





