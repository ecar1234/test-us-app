import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetDriver {
  final String? baseUrl;
  NetDriver(this.baseUrl);
  final logger = Logger();
  final dio = Dio();

  Future<Map<String, dynamic>> requestGetJson(String token, String url,
      {String? parma = ""}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    if(token != "" || token != ''){
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url/$parma';
    final res = await dio.get(api, options: Options(
      validateStatus: (status) {
        return status != null && status < 500;
      }
    ));
    if(res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      logger.w(res.data);
      return res.data;
    }
  }
  Future<Map<String, dynamic>> requestPostJson(String token, String url, Map<String, dynamic> data) async {
    dio.options.headers['Content-Type'] = 'application/json';
    if(token != "" || token != ''){
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';
    
    try {
      final res = await dio.post(api, data: data, options: Options(
        validateStatus: (status) {
          return status != null && status < 500;
        }
      ));
      if(res.statusCode == 200) {
        return res.data;
      } else {
        logger.e("${res.statusCode} : ${res.statusMessage}");
        return res.data;
      }
    } on DioException catch (e) {
      logger.e(e.response?.data);
      return e.response?.data;
    }
  }
  Future<Map<String, dynamic>> requestPutJson(String token, String url, Map<String, dynamic> data) async {
    dio.options.headers['Content-Type'] = 'application/json';
    if(token != "" || token != ''){
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';
    final res = await dio.put(api, data: data);
    if(res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      return res.data;
    }
  }
  Future<Map<String, dynamic>> requestDeleteJson(String token, String url) async {
    dio.options.headers['Content-Type'] = 'application/json';
    // dio.options.headers['Authorization'] = 'Bearer $token';
    final api = '$baseUrl$url';
    final res = await dio.delete(api);
    if(res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      return res.data;
    }
  }
}