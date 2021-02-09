import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/repositories/load_data_repository.dart';
import 'package:coffee_app/ui/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseApi.jwt = prefs.getString('ACCESS_TOKEN');
    if (currentUser != null) {
      await loadDataRepo.loadUserInfo(currentUser.uid).then((user) => {
            if (user != null)
              {
                user.address != null
                    ? prefs.setString('ADDRESS', user.address)
                    : prefs.setString('ADDRESS', 'not yet'),
                user.phone != null
                    ? prefs.setString('PHONE', user.phone)
                    : prefs.setString('PHONE', ' not yet'),
                 orderRepo.getOrderId(currentUser.uid),
              }
          });

      print('address: ' + prefs.getString('ADDRESS'));
      print('phone: ' + prefs.getString('PHONE'));
    }
  }

  @override
  void dispose() {
    BadgeValue.numProductsNotifier.dispose();
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
