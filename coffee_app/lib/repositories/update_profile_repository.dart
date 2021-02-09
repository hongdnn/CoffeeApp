import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'refresh_token_repository.dart';

class UpdateProfileRepository {
  var baseApi = BaseApi(true, true);
  Response response;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<int> updateUser(
      String id, String image, String name, String phoneNumber) async {
    try {
      response = await baseApi.dio.put("/users/update/id/" + id,
          data: {'fullname': name, 'phone': phoneNumber, 'image': image});
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        String description = e.response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            refreshToken()
                .whenComplete(() => {updateUser(id, image, name, phoneNumber)});
          }
        }
      } else {
        print("error:" + e.response.statusCode.toString());
      }
    }
    return response.statusCode;
  }

  Future<int> updateAddress(String id, String address) async {
    try {
      response = await baseApi.dio
          .put("/users/update/address/id/" + id, data: {'address': address});
      print(response.statusCode);
    } on DioError catch (e) {
      if (e.response.statusCode == 401) {
        String description = e.response.headers.value('WWW-Authenticate');
        if (description != null) {
          print(description);
          if (description.contains('expired')) {
            refreshToken().whenComplete(() => {updateAddress(id, address)});
          }
        }
      } else {
        print("update address error");
      }
    }
    return response.statusCode;
  }
}
