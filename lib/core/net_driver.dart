import 'package:dio/dio.dart';

class NetDriver {
  final String? baseUrl;
  NetDriver(this.baseUrl);

  final dio = Dio();

  Future<Map<String, dynamic>> requestGetJson(String token, String url) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final api = '$baseUrl$url';
    final res = await dio.get(api);
    if(res.statusCode == 200) {
      return res.data;
    } else {
      throw Exception('Error');
    }
  }
  Future<Map<String, dynamic>> requestPostJson(String token, String url, Map<String, dynamic> data) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final api = '$baseUrl$url';
    final res = await dio.post(api, data: data);
    if(res.statusCode == 200) {
      return res.data;
    } else {
      throw Exception('Error');
    }
  }
  Future<Map<String, dynamic>> requestPutJson(String token, String url, Map<String, dynamic> data) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final api = '$baseUrl$url';
    final res = await dio.put(api, data: data);
    if(res.statusCode == 200) {
      return res.data;
    } else {
      throw Exception('Error');
    }
  }
  Future<Map<String, dynamic>> requestDeleteJson(String token, String url) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final api = '$baseUrl$url';
    final res = await dio.delete(api);
    if(res.statusCode == 200) {
      return res.data;
    } else {
      throw Exception('Error');
    }
  }
}