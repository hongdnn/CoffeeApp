import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/common/progress_dialog.dart';
import 'package:coffee_app/common/stateful_widget/cart.info.dart';
import 'package:coffee_app/common/stateful_widget/user_order_info.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:coffee_app/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffee_app/model/order_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/cubits/order_cubit.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/common/stateless_widget/cart_header.dart';
import 'package:coffee_app/common/stateless_widget/cart_no_item.dart';

class ShoppingCart extends StatefulWidget {
  var phone;
  var address;
  var orderId;

  ShoppingCart({this.phone, this.address, this.orderId});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final orderRepo = OrderRepository();
  Future<List<OrderDetail>> listDetails;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    listDetails = orderRepo.getOrderDetails(widget.orderId);
  }

  void calculateTotal(List<OrderDetail> list) {
    totalPrice = 0;
    for (var detail in list) {
      totalPrice += detail.quantity * detail.unitPrice;
    }
  }

  void setNewTotal(int newTotal) {
    setState(() {
      totalPrice = newTotal;
    });
  }

  void setNewTotalAndRefresh(int newTotal) {
    setState(() {
      listDetails = orderRepo.getOrderDetails(widget.orderId);
      totalPrice = newTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    setUpProgressDialog(context);
    return CubitListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderConfirmSuccess) {
          dialog.show();
        }
        if (state is OrderConfirmSuccess) {
          dialog.hide();
          BadgeValue.numProductsNotifier.value = 0;
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
          future: listDetails,
          builder: (BuildContext context,
              AsyncSnapshot<List<OrderDetail>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                body: Container(
                  width: 0,
                  height: 0,
                ),
              );
            } else {
              if (snapshot.hasData) {
                calculateTotal(snapshot.data);
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
                            userName: currentUser.displayName,
                            phone: widget.phone,
                            address: widget.address),
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
                              for (var detail in snapshot.data)
                                CartInfo(
                                    detail, setNewTotal, setNewTotalAndRefresh),
                            ],
                          ),
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
                                              '$totalPriceđ',
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            left: BorderSide(width: 1.0))),
                                    margin:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
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
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<OrderCubit>().confirmOrder(
                                    currentUser.uid, widget.orderId);
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
