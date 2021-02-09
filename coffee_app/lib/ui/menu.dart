import 'package:badges/badges.dart';
import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/cubits/order_cubit.dart';
import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/model/product.dart';
import 'package:coffee_app/model/size.dart';
import 'package:coffee_app/repositories/load_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/model/list_data.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'detail_screen.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final repo = LoadDataRepository();
  Future<ListData> listData;

  @override
  void initState() {
    super.initState();
    listData = repo.firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    return
        // CubitListener<OrderCubit, OrderState>(
        //     listener: (context, state) {
        //       if (state is OrderSuccess) {
        //         a.value += state.count;
        //         print( "number: "+a.value.toString());
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
        DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Text(
                    "Các loại thức uống",
                    style: TextStyle(fontSize: 27, color: Colors.black),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 25, top: 10),
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: ValueListenableBuilder(
                            valueListenable: BadgeValue.numProductsNotifier,
                            builder: (context, value, _) {
                              return Badge(
                                badgeContent: Text(
                                  '$value',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                showBadge: value > 0 ? true : false,
                                alignment: Alignment.topRight,
                                child: Image.asset(
                                  "assets/shopping_cart2.png",
                                  width: 40,
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                  bottom: TabBar(
                    labelStyle: TextStyle(fontSize: 21, color: Colors.black),
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: "Cà phê"),
                      Tab(text: "Đá xay"),
                      Tab(text: "Trà trái cây"),
                    ],
                  ),
                ),
                body: FutureBuilder(
                    future: listData,
                    builder: (BuildContext context,
                        AsyncSnapshot<ListData> snapshot) {
                      if (snapshot.hasData) {
                        return TabBarView(
                          children: [
                            PageWidget(snapshot.data, 1),
                            PageWidget(snapshot.data, 2),
                            PageWidget(snapshot.data, 3),
                          ],
                        );
                      }
                      return Container();
                    })));
  }
}

class PageWidget extends StatelessWidget {
  final ListData listData;
  final int type;
  PageWidget(this.listData, this.type);

  @override
  Widget build(BuildContext context) {
    List<Product> listProducts = List<Product>();
    List<Size> listSizes = List<Size>();
    if (listData.listProduct != null) {
      for (int i = 0; i < listData.listProduct.length; i++) {
        if (listData.listProduct[i].typeId == type) {
          listProducts.add(listData.listProduct[i]);
          listSizes.add(listData.listSize[i]);
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 2 / 3.3,
          children: List.generate(
            listProducts.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(
                                product: listProducts[index],
                                size: listSizes[index],
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(),
                      color: Colors.white),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          child: Hero(
                            tag: listProducts[index].image,
                            child: Image.network(
                              listProducts[index].image,
                              width: MediaQuery.of(context).size.width / 2 - 30,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 25, top: 10),
                        child: Text(
                          showProductName(listProducts[index].productName),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                listSizes[index].priceOfSizeS != null
                                    ? listSizes[index].priceOfSizeS.toString()
                                    : listSizes[index].priceOfSizeM != null
                                        ? listSizes[index]
                                            .priceOfSizeM
                                            .toString()
                                        : listSizes[index]
                                            .priceOfSizeL
                                            .toString(),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset("assets/add_to_cart.png",
                                  width: 42),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  String showProductName(String name) {
    String newName = '';
    if (name.length > 12) {
      for (int i = 0; i < 12; i++) {
        newName += name[i];
      }
      newName += '...';
      return newName;
    }
    return name;
  }
}
