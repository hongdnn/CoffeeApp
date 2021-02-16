import 'package:flutter/material.dart';
import 'package:coffee_app/model/order_detail.dart';
import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/repositories/order_repository.dart';

class CartInfo extends StatefulWidget {
  OrderDetail orderDetail;
  final Function(int) callback;
  final Function(int) callbackAndRefresh;

  CartInfo(this.orderDetail, this.callback, this.callbackAndRefresh);

  @override
  _CartInfoState createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> {
  final orderRepo = OrderRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 18, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        deleteProduct();
                      },
                      child: Image.asset(
                        'assets/cancel.png',
                        height: 14,
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.orderDetail.productName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 6.5),
                    child: Text(
                        (widget.orderDetail.unitPrice *
                                    widget.orderDetail.quantity)
                                .toString() +
                            'đ',
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 35),
                  child: Text(
                    widget.orderDetail.size == 'S'
                        ? 'Nhỏ'
                        : widget.orderDetail.size == 'M'
                            ? 'Vừa'
                            : widget.orderDetail.size == 'L'
                                ? 'Lớn'
                                : '',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (widget.orderDetail.quantity > 1) {
                      updateDetailAmount(0);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 8,
                    height: MediaQuery.of(context).size.height / 22,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Text(
                      '-',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 9,
                  height: MediaQuery.of(context).size.height / 22,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    widget.orderDetail.quantity.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      if (widget.orderDetail.quantity < 20) {
                        updateDetailAmount(1);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 8,
                      height: MediaQuery.of(context).size.height / 22,
                      margin: const EdgeInsets.only(
                        right: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ])),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(width: 0.8), bottom: BorderSide(width: 0.4))),
    );
  }

  void updateDetailAmount(int mode) async {
    int result = await orderRepo.updateOrderAmount(widget.orderDetail.detailId,
        widget.orderDetail.unitPrice, widget.orderDetail.orderId, mode);
    if (result != -1) {
      if (mode == 1) {
        widget.orderDetail.quantity++;
      } else {
        widget.orderDetail.quantity--;
      }
      widget.callback(result);
    }
  }

  void deleteProduct() async {
    int result = await orderRepo.deleteProduct(
        widget.orderDetail.detailId,
        widget.orderDetail.unitPrice,
        widget.orderDetail.orderId,
        widget.orderDetail.quantity);
    if (result != -1) {
      BadgeValue.numProductsNotifier.value--;
      widget.callbackAndRefresh(result);
    }
  }
}
