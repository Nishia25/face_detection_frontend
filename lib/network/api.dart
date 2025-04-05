import 'package:dio/dio.dart';

class Api {
  // Api._();
  late Dio _dio;

  Dio get dio => _dio;

  Api() {
    _dio = Dio(BaseOptions(
      baseUrl: " ",
      connectTimeout: Duration(minutes: 2),
      headers: {"Content-Type": "application/json"},
      contentType: "application/json",
    ));
  }
}
