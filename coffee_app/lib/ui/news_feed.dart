import 'package:badges/badges.dart';
import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/cubits/order_cubit.dart';
import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/model/list_data.dart';
import 'package:coffee_app/model/product.dart';
import 'package:coffee_app/model/size.dart';
import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:coffee_app/repositories/load_data_repository.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_app/model/coupon.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'dart:io';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  int currentIndex = 0;
  final repo = LoadDataRepository();
  final authrepo = AuthenticateRepository();
  List<Widget> imagewidgets;
  Future<List<Coupon>> coupons;
  Future<ListData> listData;
  List<Product> products = [];
  List<Size> sizes = [];

  @override
  void initState() {
    super.initState();
    coupons = repo.getAllCoupons();
    listData = repo.firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    return
        // CubitListener<OrderCubit, OrderState>(
        //     listener: (context, state) {
        //       if (state is OrderSuccess) {
        //         numOfProducts += state.count;
        //         showBadge = true;
        //       } else if (state is OrderFailure) {
        //         Fluttertoast.showToast(
        //             msg: "Rất tiếc. Đã có lỗi xảy ra",
        //             toastLength: Toast.LENGTH_LONG,
        //             gravity: ToastGravity.BOTTOM,
        //             timeInSecForIosWeb: 1,
        //             backgroundColor: Colors.red,
        //             textColor: Colors.white,
        //             fontSize: 20);
        //       }
        //     },
        //     child:
        Scaffold(
            body: Stack(children: <Widget>[
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: FutureBuilder(
                future: coupons,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Coupon>> snapshot) {
                  Widget resultWidget;
                  if (snapshot.hasData) {
                    loadCouponImages(snapshot.data);
                    resultWidget = CarouselSlider(
                      items: imagewidgets,
                      options: CarouselOptions(
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1500),
                          viewportFraction: 1,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          }),
                    );
                  } else {
                    resultWidget = Center(
                      child: Container(
                        width: 350,
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                          child: Image.network(
                            "https://media2.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif",
                            fit: BoxFit.fitHeight,
                            width: 350,
                          ),
                        ),
                      ),
                    );
                  }
                  return resultWidget;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: FutureBuilder(
                  future: listData,
                  builder:
                      (BuildContext context, AsyncSnapshot<ListData> snapshot) {
                    Widget resultWidget;
                    if (snapshot.hasData) {
                      resultWidget = Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 15.0),
                          color: Color.fromRGBO(112, 170, 48, 1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 25),
                                    child: Text(
                                      "Sản phẩm mới",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20, top: 25),
                                      child: Text(
                                        "Xem tất cả",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 180,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        reverse: false,
                                        addAutomaticKeepAlives: true,
                                        itemCount:
                                            snapshot.data.listProduct.length,
                                        itemBuilder: (context, index) {
                                          if (index <
                                              snapshot.data.listProduct.length -
                                                  3) return SizedBox();
                                          return productWidget(
                                              snapshot.data, index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    } else {
                      resultWidget = Container();
                    }
                    return resultWidget;
                  }),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 76,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ClipOval(
                  child: currentUser != null
                      ? currentUser.photoURL != null
                          ? currentUser.photoURL.contains('image_picker')
                              ? Image.file(
                                  File(currentUser.photoURL),
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  currentUser.photoURL,
                                  width: 50,
                                )
                          : Image.asset(
                              "assets/user.png",
                              width: 50,
                            )
                      : Image.asset(
                          "assets/user.png",
                          width: 50,
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: currentUser != null
                    ? Text(
                        currentUser.displayName,
                        style: TextStyle(fontSize: 20),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 15,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          color: Color.fromRGBO(112, 170, 48, 1.0),
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        ),
                      ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 25.0, bottom: 1),
                child: ValueListenableBuilder(
                  valueListenable: BadgeValue.numProductsNotifier,
                  builder: (context, value, _) {
                    return Badge(
                      badgeContent: Text(
                        '$value',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      showBadge: value > 0 ? true : false,
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        "assets/shopping_cart2.png",
                        width: 40,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.only(bottom: 50.0),
        ),
      ),
    ]));
  }

  void loadCouponImages(List<Coupon> list) {
    imagewidgets = list
        .map(
          (item) => Container(
            child: Visibility(
              visible: list.indexOf(item) == currentIndex ? true : false,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item.image,
                        fit: BoxFit.fill,
                        width: 350,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: list.map((url) {
                              int index = list.indexOf(url);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentIndex == index
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        )
        .toList();
  }

  Widget productWidget(ListData listData, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      alignment: Alignment.centerLeft,
      width: 330,
      margin: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
              child: Image.network(listData.listProduct[index].image,
                  height: 150)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: Text(
                  showProductName(listData.listProduct[index].productName),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  listData.listSize[index].priceOfSizeS != null
                      ? listData.listSize[index].priceOfSizeS.toString()
                      : listData.listSize[index].priceOfSizeM.toString(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: SizedBox(
                    width: 150,
                    height: 45,
                    child: RaisedButton(
                      child: Text(
                        "Đặt ngay",
                        style: TextStyle(fontSize: 22),
                      ),
                      color: Color.fromRGBO(112, 170, 48, 1.0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                      product: listData.listProduct[index],
                                      size: listData.listSize[index],
                                    )));
                      },
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  String showProductName(String name) {
    String newName = '';
    if (name.length > 13) {
      for (int i = 0; i < 13; i++) {
        newName += name[i];
      }
      newName += '...';
      return newName;
    }
    return name;
  }
}
