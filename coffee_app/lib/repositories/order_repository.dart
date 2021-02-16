import 'dart:convert';
import 'package:coffee_app/model/order_response_result.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'refresh_token_repository.dart';
import 'package:coffee_app/common/badge_value.dart';
import 'package:coffee_app/model/order_detail.dart';
import 'package:coffee_app/model/order_detail_response_result.dart';

class OrderRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
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
            String jwt = await refreshToken();
            if (jwt != null) {
              return -2;
            }
          }
        }
      } else {
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
            String jwt = await refreshToken();
            if (jwt != null) {
              return -2;
            }
          }
        }
      } else {
        print('error insert order');
      }
    }
    return -1;
  }

  Future<Response> loadOrderId(String id) async {
    try {
      response = await baseApi.dio.get("/orders/userid/" + id);
      if (response.statusCode == 200 || response.statusCode == 400) {
        final orderResponse =
            OrderResponse.getAmountfromJson(json.decode(response.data));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('EXISTED_ORDER', orderResponse.orderId);
        if (orderResponse.amountDetail > 0) {
          BadgeValue.numProductsNotifier.value = orderResponse.amountDetail;
        }
      }
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<void> getOrderId(String id) async {
    Response res = await loadOrderId(id);
    if (res.statusCode == 401) {
      String description = res.headers.value('WWW-Authenticate');
      if (description != null) {
        print(description);
        if (description.contains('expired')) {
          String jwt = await refreshToken();
          if (jwt != null) {
            await loadOrderId(id);
          }
        }
      }
    } else if (res.statusCode != 200 && res.statusCode != 400) {
      print('error get order id');
    }
  }

  Future<Response> loadOrderDetails(int orderId) async {
    try {
      response =
          await baseApi.dio.get("/orderdetails/orderid/" + orderId.toString());
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    Response res = await loadOrderDetails(orderId);
    if (res.statusCode == 200) {
      var detailsResponse = OrderDetailResponse.fromJson(json.decode(res.data));
      return detailsResponse.orderDetails;
    } else if (res.statusCode == 401) {
      String description = res.headers.value('WWW-Authenticate');
      if (description != null) {
        print(description);
        if (description.contains('expired')) {
          String jwt = await refreshToken();
          if (jwt != null) {
            var result = await loadOrderDetails(orderId);
            if (result.statusCode == 200) {
              var detailsResponse =
                  OrderDetailResponse.fromJson(json.decode(result.data));
              return detailsResponse.orderDetails;
            }
          }
        }
      }
    } else {
      print('error get order id');
      return null;
    }
    return null;
  }

  Future<int> confirmCart(String userId, int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      response = await baseApi.dio.put("/orders/confirm", data: {
        'userId': userId,
        'orderId': orderId,
      });
      if (response.statusCode == 200) {
        prefs.remove('EXISTED_ORDER');
        BadgeValue.numProductsNotifier.value = 0;
        return response.statusCode;
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 401) {
          String description = response.headers.value('WWW-Authenticate');
          if (description != null) {
            print(description);
            if (description.contains('expired')) {
              String jwt = await refreshToken();
              if (jwt != null) {
                return e.response.statusCode;
              }
            }
          }
        }
        return e.response.statusCode;
      } else {
        print('unknown error');
      }
    }
    return -1;
  }

  Future<Response> updateOrderDetails(
      int orderDetailId, int unitPrice, int orderId, int mode) async {
    try {
      response = await baseApi.dio.put("/orderdetails", data: {
        'orderDetailId': orderDetailId,
        'unitPrice': unitPrice,
        'orderId': orderId,
        'userId': currentUser.uid,
        'mode': mode,
      });
      return response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Map<String, dynamic> map = jsonDecode(e.response.data);
        print(map['message']);
      }
      return e.response;
    }
  }

  Future<int> updateOrderAmount(
      int orderDetailId, int unitPrice, int orderId, int mode) async {
    Response res =
        await updateOrderDetails(orderDetailId, unitPrice, orderId, mode);
    if (res.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(res.data);
      return map['totalPrice'];
    } else if (res.statusCode == 401) {
      String description = res.headers.value('WWW-Authenticate');
      if (description != null) {
        print(description);
        if (description.contains('expired')) {
          String jwt = await refreshToken();
          if (jwt != null) {
            Response result = await updateOrderDetails(
                orderDetailId, unitPrice, orderId, mode);
            if (result.statusCode == 200) {
              Map<String, dynamic> map = jsonDecode(res.data);
              return map['totalPrice'];
            }
          }
        }
      }
    } else if (res.statusCode != 400) {
      print('error update amount');
    }
    return -1;
  }

  Future<Response> deleteOrderDetails(
      int orderDetailId, int unitPrice, int orderId, int quantity) async {
    try {
      response = await baseApi.dio.delete("/orderdetails", data: {
        'orderDetailId': orderDetailId,
        'unitPrice': unitPrice,
        'orderId': orderId,
        'userId': currentUser.uid,
        'quantity': quantity,
      });
      return response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        Map<String, dynamic> map = jsonDecode(e.response.data);
        print(map['message']);
      }
      return e.response;
    }
  }

  Future<int> deleteProduct(
      int orderDetailId, int unitPrice, int orderId, int quantity) async {
    Response res =
        await deleteOrderDetails(orderDetailId, unitPrice, orderId, quantity);
    if (res.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(res.data);
      return map['totalPrice'];
    } else if (res.statusCode == 401) {
      String description = res.headers.value('WWW-Authenticate');
      if (description != null) {
        print(description);
        if (description.contains('expired')) {
          String jwt = await refreshToken();
          if (jwt != null) {
            Response result = await deleteOrderDetails(
                orderDetailId, unitPrice, orderId, quantity);
            if (result.statusCode == 200) {
              Map<String, dynamic> map = jsonDecode(res.data);
              return map['totalPrice'];
            }
          }
        }
      }
    } else if (res.statusCode != 400) {
      print('error update amount');
    }
    return -1;
  }
}
