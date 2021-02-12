import 'package:coffee_app/utils/base_api.dart';
import 'package:coffee_app/model/response_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

Future<String> refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String refreshToken = prefs.getString('REFRESH_TOKEN');
  var baseApi = BaseApi(true, false);
  var response;
  try {
    response = await baseApi.dio.post('/users/refresh-token', data: {
      'token': BaseApi.jwt,
      'refreshToken': refreshToken,
    });
    final responseResult = ResponseResult.fromJson(json.decode(response.data));
    await prefs.setString('ACCESS_TOKEN', responseResult.accessToken);
    await prefs.setString('REFRESH_TOKEN', responseResult.refreshToken);
    BaseApi.jwt = responseResult.accessToken;
    print('refresh: '+BaseApi.jwt);
    return responseResult.accessToken;
  } on DioError catch (e) {
    print(e.error);
  }
  return null;
}
