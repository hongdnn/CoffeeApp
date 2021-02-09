import 'dart:convert';
import 'package:coffee_app/model/order_response_result.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'refresh_token_repository.dart';
import 'package:coffee_app/common/badge_value.dart';

class OrderRepository {
  var baseApi = BaseApi(true, true);
  Response response;
  Future<int> insertOrderDetail(int orderId, String productId,
      String productName, String size, int quantity, int unitPrice) async {
    try {
      response = await baseApi.dio.post("/orderdetails", data: {
        'orderId': orderId,
        'productId': productId,
        'productName': productName,
        'size': size,
        'quantity': quantity,
        'unitPrice': unitPrice,
      });
      return response.statusCode;
    } on DioError catch (e) {
      print(BaseApi.jwt);
      if (e.response.statusCode == 401) {
        String description = e.response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            refreshToken().whenComplete(() => {
                  insertOrderDetail(orderId, productId, productName, size,
                      quantity, unitPrice)
                });
          }
        }
      } else {
        print(e.response.statusCode);
        return e.response.statusCode;
      }
    }
    return 0;
  }

  Future<int> insertOrder(int totalPrice) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var address = prefs.getString('ADDRESS');
    var phone = prefs.getString('PHONE');
    try {
      response = await baseApi.dio.post("/orders", data: {
        'userId': currentUser.uid,
        'address': address,
        'receiverName': currentUser.displayName,
        'phone': phone,
        'totalPrice': totalPrice,
      });
      if (response.statusCode == 200) {
        final orderId =
            OrderResponse.fromJson(json.decode(response.data)).orderId;
        prefs.setInt('EXISTED_ORDER', orderId);
        return orderId;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        String description = e.response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            refreshToken().whenComplete(() => {insertOrder(totalPrice)});
          }
        }
      } else {
        print('error insert order');
      }
    }
    return -1;
  }

  Future<int> getOrderId(String id) async {
    try {
      response = await baseApi.dio.get("/orders/userid/" + id);
      if (response.statusCode == 200) {
        final orderResponse =
            OrderResponse.getAmountfromJson(json.decode(response.data));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('EXISTED_ORDER', orderResponse.orderId);
        BadgeValue.numProductsNotifier.value = orderResponse.amountDetail;
        return orderResponse.orderId;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        String description = e.response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            refreshToken().whenComplete(() => {getOrderId(id)});
          }
        }
      } else {
        print('error get order id');
        return e.response.statusCode;
      }
    }
    return -1;
  }
}
