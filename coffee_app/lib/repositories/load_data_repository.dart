import 'dart:async';
import 'package:coffee_app/model/my_user.dart';
import 'package:coffee_app/model/coupon.dart';
import 'package:coffee_app/model/list_data.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'refresh_token_repository.dart';

class LoadDataRepository {
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
    var baseAPI = BaseApi(true, false);
    try {
      response = await baseAPI.dio.get("/coupons");
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

  Future<MyUser> loadUserInfo(String id) async {
    var baseAPI = BaseApi(true, true);
    try {
      response = await baseAPI.dio.get("/users/id/" + id);
      // .catchError((e) => {
      //       if (e.error == "Http status error [401]")
      //         {
      //           refreshToken().whenComplete(() => {loadUserInfo(id)})
      //         }
      //       else
      //         {print("error get user")}
      //     });
      if (response.statusCode == 200) {
        return MyUser.fromJson(json.decode(response.data));
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        String description = e.response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            refreshToken().whenComplete(() => {loadUserInfo(id)});
          }
        }
      } else {
        print("error get user");
      }
    }
    return null;
  }
}
