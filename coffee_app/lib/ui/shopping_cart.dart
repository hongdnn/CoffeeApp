import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/common/progress_dialog.dart';
import 'package:coffee_app/common/stateful_widget/cart.info.dart';
import 'package:coffee_app/common/stateful_widget/user_order_info.dart';
import 'package:coffee_app/common/stateless_widget/coupon_detail.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:coffee_app/ui/coupon_screen.dart';
import 'package:coffee_app/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/cubits/order_cubit.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/common/stateless_widget/cart_header.dart';
import 'package:coffee_app/common/stateless_widget/cart_no_item.dart';
import 'package:hive/hive.dart';
import 'package:coffee_app/model/my_user.dart';
import 'package:coffee_app/model/coupon.dart';
import 'package:coffee_app/model/order_detail_response_result.dart';

class ShoppingCart extends StatefulWidget {
  var orderId;

  ShoppingCart({this.orderId});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final orderRepo = OrderRepository();
  Future<OrderDetailResponse> orderDetailResponse;
  int totalPrice = 0;
  int salePrice = 0;
  int orderPrice = 0;
  MyUser user;
  Coupon coupon;

  @override
  void initState() {
    super.initState();
    var box = Hive.box('hiveBox');
    user = box.get('user');
    coupon = box.get('coupon');
    orderDetailResponse = orderRepo.getOrderDetails(widget.orderId);
  }

  int getSalePrice(int price) {
    if (coupon != null) {
      if (coupon.sale.contains('%')) {
        int sale = int.parse(coupon.sale.split('%')[0]);
        double res = price * sale / 100;
        return res.round();
      } else {
        return int.parse(coupon.sale);
      }
    }
    return 0;
  }

  void setNewTotal(int newTotal) {
    setState(() {
      totalPrice = newTotal;
    });
  }

  void setNewTotalAndRefresh(int newTotal) {
    setState(() {
      orderDetailResponse = orderRepo.getOrderDetails(widget.orderId);
      totalPrice = newTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    setUpProgressDialog(context);
    return CubitListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderConfirmProgress) {
          dialog.show();
        }
        if (state is OrderConfirmSuccess) {
          dialog.hide();
          BadgeValue.numProductsNotifier.value = 0;
          var box = Hive.box('hiveBox');
          box.delete('coupon');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        currentIndex: 0,
                      )),
              (route) => false);
        } else if (state is OrderConfirmFailure) {
          dialog.hide();
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
      child: FutureBuilder(
          future: orderDetailResponse,
          builder: (BuildContext context,
              AsyncSnapshot<OrderDetailResponse> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                body: Container(
                  width: 0,
                  height: 0,
                ),
              );
            } else {
              if (snapshot.hasData) {
                if (totalPrice == 0) {
                  totalPrice = snapshot.data.totalPrice;
                }
                salePrice = getSalePrice(totalPrice);
                orderPrice = totalPrice - salePrice;
                return Scaffold(
                    body: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 120, left: 20, bottom: 10),
                          child: Text(
                            'Thông tin khách hàng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        UserOrderInfo(
                            userName: user.fullname,
                            phone: user.phone,
                            address: user.address),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, bottom: 10),
                          child: Text(
                            'Thông tin đơn hàng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              for (var detail in snapshot.data.orderDetails)
                                CartInfo(
                                    detail, setNewTotal, setNewTotalAndRefresh),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, bottom: 10),
                          child: Text(
                            'Tổng cộng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: ListTile(
                            leading: Text(
                              'Tổng cộng',
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                              '${totalPrice.toString()}đ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(width: 0.8),
                                  bottom: BorderSide(width: 0.8))),
                        ),
                        salePrice != 0
                            ? Container(
                                child: ListTile(
                                  leading: Text(
                                    'Khuyến mãi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(112, 170, 48, 1.0),
                                    ),
                                  ),
                                  trailing: Text(
                                    '-${salePrice.toString()}đ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(112, 170, 48, 1.0),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        top: BorderSide(width: 0.8),
                                        bottom: BorderSide(width: 0.8))),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                        Container(
                          height: 200,
                        )
                      ])),
                  CartHeader('Giỏ hàng của bạn'),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(top: BorderSide(width: 0.5)),
                            color: Colors.white),
                        height: 160,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              '$orderPriceđ',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ),
                                          Text(
                                            'Tiền mặt',
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (coupon != null) {
                                        showModalBottomSheet(
                                            context: context,
                                            routeSettings: RouteSettings(
                                                arguments: totalPrice),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          25.0)),
                                            ),
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return CouponDetail(
                                                coupon,
                                                true,
                                              );
                                            });
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CouponScreen(),
                                                settings: RouteSettings(
                                                    arguments: totalPrice)));
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              left: BorderSide(width: 1.0))),
                                      margin: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          coupon != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(coupon.couponId,
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          color: Color.fromRGBO(
                                                              253,
                                                              78,
                                                              38,
                                                              1.0))),
                                                )
                                              : Image.asset(
                                                  'assets/coupon.png',
                                                  height: 45,
                                                ),
                                          Text(
                                            'Mã ưu đãi',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<OrderCubit>().confirmOrder(
                                    currentUser.uid,
                                    widget.orderId,
                                    coupon != null ? coupon.couponId : null,
                                    orderPrice);
                              },
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                color: Color.fromRGBO(112, 170, 48, 1.0),
                                child: Center(
                                  child: Text(
                                    'Đặt hàng',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ]));
              } else {
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: Stack(children: <Widget>[
                      CartNoItem(),
                      CartHeader('Giỏ hàng của bạn'),
                    ]));
              }
            }
          }),
    );
  }
}
