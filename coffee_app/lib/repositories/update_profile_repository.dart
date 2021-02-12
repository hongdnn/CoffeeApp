import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'refresh_token_repository.dart';

class UpdateProfileRepository {
  var baseApi = BaseApi(true, true);
  Response response;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Response> getResponseUpdateUser(
      String id, String image, String name, String phoneNumber) async {
    try {
      response = await baseApi.dio.put("/users/update/id/" + id,
          data: {'fullname': name, 'phone': phoneNumber, 'image': image});
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<int> updateUser(
      String id, String image, String name, String phoneNumber) async {
    Response res = await getResponseUpdateUser(id, image, name, phoneNumber);
    if (res.statusCode == 200) {
      return res.statusCode;
    }
    if (res.statusCode == 401) {
      String description = res.headers.value('WWW-Authenticate');
      if (description != null) {
        print(description);
        String jwt = await refreshToken();
        if (jwt != null) {
          var result =
              await getResponseUpdateUser(id, image, name, phoneNumber);
          if (result.statusCode == 200) {
            return result.statusCode;
          }
        }
      }
    } else {
      print("error:" + res.statusCode.toString());
    }
    return res.statusCode;
  }

  Future<Response> getResponseUpdateAddress(String id, String address) async {
    try {
      response = await baseApi.dio
          .put("/users/update/address/id/" + id, data: {'address': address});
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<int> updateAddress(String id, String address) async {
    Response res = await getResponseUpdateAddress(id, address);
    if (res.statusCode == 200) {
      return res.statusCode;
    } else if (res.statusCode == 401) {
      String description = res.headers.value('WWW-Authenticate');
      if (description != null) {
        if (description.contains('expired')) {
          String jwt = await refreshToken();
          if (jwt != null) {
            var result = await getResponseUpdateAddress(id, address);
            if (result.statusCode == 200) {
              return result.statusCode;
            }
          }
        }
      }
    } else {
      print("update address error");
    }
    return res.statusCode;
  }
}
