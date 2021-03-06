import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/repositories/load_data_repository.dart';
import 'package:coffee_app/ui/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu.dart';
import 'news_feed.dart';
import 'package:coffee_app/cubits/order_cubit.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'package:coffee_app/repositories/order_repository.dart';

class HomePage extends StatefulWidget {
  int currentIndex;

  HomePage({this.currentIndex});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final loadDataRepo = LoadDataRepository();
  final orderRepo = OrderRepository();
  final List<Widget> _pageWidgets = <Widget>[
    NewsFeedPage(),
    MenuPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  void getUserInfo() async {
    var box = Hive.box('hiveBox');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseApi.jwt = prefs.getString('ACCESS_TOKEN');
    if (currentUser != null) {
      await loadDataRepo.getUser(currentUser.uid).then((user) => {
            print(user),
            if (user != null)
              {
                if (user.phone == null) {user.phone = 'not yet'},
                if (user.address == null) {user.address = 'not yet'},
                box.put('user', user)
              },
            orderRepo.getOrderId(user.userId),
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CubitListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          BadgeValue.numProductsNotifier.value += state.count;
        } else if (state is OrderFailure) {
          Fluttertoast.showToast(
              msg: "Rất tiếc. Đã có lỗi xảy ra",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 20);
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }
}
