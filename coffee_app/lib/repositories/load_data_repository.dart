import 'dart:async';
import 'dart:io';
import 'package:coffee_app/model/my_user.dart';
import 'package:coffee_app/model/coupon.dart';
import 'package:coffee_app/model/list_data.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoadDataRepository {
  Future<ListData> firstLoad() async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    final Response response =
        await dio.get("https://10.0.2.2:5001/api/products");
    if (response.statusCode == 200) {
      return ListData.fromJson(json.decode(response.data));
    } else {
      print(response.statusCode);
    }
    return null;
  }

  Future<List<Coupon>> getAllCoupons() async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    final Response response =
        await dio.get("https://10.0.2.2:5001/api/coupons");
    if (response.statusCode == 200) {
      return (json.decode(response.data) as List)
          .map((i) => Coupon.fromJson(i))
          .toList();
    } else {
      print(response.statusCode);
    }
    return null;
  }

  Future<MyUser> loadUserInfo(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    print(prefs.getString('ACCESS_TOKEN'));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        'Bearer ' + prefs.getString('ACCESS_TOKEN');
    final Response response = await dio
        .get("https://10.0.2.2:5001/api/users/id/"+id);
    if (response.statusCode == 200) {
      return MyUser.fromJson(json.decode(response.data));
    } else {
      print(response.statusCode);
    }
    return null;
  }
}
