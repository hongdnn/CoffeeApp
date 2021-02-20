import 'dart:async';
import 'package:coffee_app/model/my_user.dart';
import 'package:coffee_app/model/coupon.dart';
import 'package:coffee_app/model/list_data.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'refresh_token_repository.dart';

class LoadDataRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  var baseAPI = BaseApi(true, true);
  Response response;
  Future<ListData> firstLoad() async {
    var baseAPI = BaseApi(true, false);
    try {
      response = await baseAPI.dio.get("/products");
      if (response.statusCode == 200) {
        return ListData.fromJson(json.decode(response.data));
      }
    } on DioError {
      print(response.statusCode);
    }
    return null;
  }

  Future<List<Coupon>> getAllCoupons() async {
    try {
      response = await baseAPI.dio.get("/coupons/userid/" + currentUser.uid);
      if (response.statusCode == 200) {
        return (json.decode(response.data) as List)
            .map((i) => Coupon.fromJson(i))
            .toList();
      }
    } on DioError {
      print(response.statusCode);
    }
    return null;
  }

  Future<Response> loadUserInfo(String id) async {
    try {
      print(BaseApi.jwt);
      response = await baseAPI.dio.get("/users/id/" + id);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<MyUser> getUser(String id) async {
    MyUser myUser;
    Response response = await loadUserInfo(id);
    if (response.statusCode == 200) {
      return MyUser.fromJson(json.decode(response.data));
    } else {
      myUser = null;
      if (response.statusCode == 401) {
        String description = response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            String jwt = await refreshToken();
            if (jwt != null) {
              var result = await loadUserInfo(id);
              if (result.statusCode == 200) {
                myUser = MyUser.fromJson(json.decode(result.data));
              }
            }
          }
        }
      } else {
        print("error get user");
      }
    }
    return myUser;
  }
}
