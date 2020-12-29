import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UpdateProfileRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<int> updateUser(
      String id, String image, String name, String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    print('jwt: '+prefs.getString('ACCESS_TOKEN'));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        'Bearer ' + prefs.getString('ACCESS_TOKEN');
   final response =  await dio.put(
        "https://10.0.2.2:5001/api/users/update/id/" + id,
        data: {'fullname': name, 'phone': phoneNumber, 'image': image});
    print(response.statusCode);
    if(response.statusCode == 400){
      print("error:"+ json.decode(response.data));
    }
    return response.statusCode;
  }

  Future<int> updateAddress(String id, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        'Bearer ' + prefs.getString('ACCESS_TOKEN');
    final Response response = await dio.put(
        "https://10.0.2.2:5001/api/users/update/address/id/" + id,
        data: {'address': address});
    print(response.statusCode);
    return response.statusCode;
  }
}
