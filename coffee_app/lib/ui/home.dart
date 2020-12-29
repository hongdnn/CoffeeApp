import 'package:coffee_app/ui/profile.dart';
import 'package:flutter/material.dart';
import 'menu.dart';
import 'news_feed.dart';

class HomePage extends StatefulWidget {
  int currentIndex;

  HomePage({ this.currentIndex});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  //ListData listData;
  final List<Widget> _pageWidgets = <Widget>[
    NewsFeedPage(),
    MenuPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: widget.currentIndex, children: _pageWidgets),
      bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, 
       currentIndex: widget.currentIndex,
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
     widget.currentIndex = index;
   });
 }
}





