import 'dart:io' show HttpClient, Platform, X509Certificate;
import 'package:coffee_app/utils/setting.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'api_error.dart';

class BaseApi {
  Dio dio;
  static String jwt;
  final bool requireJwt;
  final bool debug;

  BaseApi(this.debug, this.requireJwt) {
    //Setup the option for dio
    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      followRedirects: false,
      receiveTimeout: 60000,
      connectTimeout: 60000,
    );

    //init the dio object
    dio = Dio(options);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    //enable debugger to log the request/response header
    if (debug ?? false) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }

    //add interceptor for add JWT
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (Options options) {
        options.headers["AppPlatform"] = getMappedPlatformName();
        options.headers['content-Type'] = 'application/json';

        if (this.requireJwt) {
          options.headers["authorization"] = 'Bearer ' + jwt;
          return options;
        } else {
          return options;
        }
      }),
    );
  }

  static String getMappedPlatformName() {
    String name = 'Unknown';

    if (Platform.isAndroid) {
      name = 'Android';
    } else if (Platform.isIOS) {
      name = 'iOS';
    } else if (Platform.isWindows) {
      name = 'Windows';
    } else if (Platform.isLinux) {
      name = 'Linux';
    } else if (Platform.isMacOS) {
      name = 'MacOS';
    } else if (Platform.isFuchsia) {
      name = 'Fuchsia';
    }

    return name;
  }

  //Handing error of request
  ApiError handleError(DioError error) {
    int statusCode = 0;
    List<String> errors = List<String>();

    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.SEND_TIMEOUT:
          errors.add('api_error_send_timeout');
          break;
        case DioErrorType.CANCEL:
          errors.add('api_error_cancel');
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errors.add('api_error_connect_timeout');
          break;
        case DioErrorType.DEFAULT:
          errors.add('api_error_default');
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errors.add('api_error_receive_timeout');
          break;
        case DioErrorType.RESPONSE:
          statusCode = error.response.statusCode;
          if (error.response.data != null && error.response.data != "") {
            if (error.response.data['error'] != null) {
              if (error.response.data['error'] is String) {
                errors.add(error.response.data['error']);
              } else if (error.response.data['error'] is List<String>) {
                errors = error.response.data['error'];
              } else if (error.response.data['error'] is List<dynamic>) {
                errors = [];
                for (int i = 0; i < error.response.data['error'].length; i++) {
                  errors.add(error.response.data['error'][i].toString());
                }
              } else if (error.response.data['error'] is Map<String, dynamic>) {
                //This is case onf /ecomaccounts/login api error
                errors = [];

                error.response.data['error']
                    .forEach((String field, dynamic errorItems) {
                  if (errorItems is String) {
                    errors.add(errorItems);
                  } else if (errorItems is List<dynamic>) {
                    errors = errors + errorItems.cast();
                  }
                });
              }
            }
          }
          break;
      }
    } else {
      errors.add(error.message);
    }

    return ApiError(statusCode, errors);
  }
}
