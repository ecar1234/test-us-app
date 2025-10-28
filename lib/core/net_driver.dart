import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../data/models/image/image_model.dart';
import '../data/models/post/promotion_post_model.dart';
import '../data/models/post/recruit_post_model.dart';

class NetDriver {
  final String? baseUrl;

  NetDriver(this.baseUrl);

  final logger = Logger();
  final dio = Dio();

  Future<Map<String, dynamic>> requestGetJson(String token, String url, {String? param = ""}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    if (token != "" || token != '') {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url/$param';
    // logger.d(api);
    final res = await dio.get(api, options: Options(validateStatus: (status) {
      return status != null && status < 500;
    }));
    if (res.statusCode == 200 || res.statusCode == 202) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      logger.w(res.data);
      return res.data;
    }
  }

  Future<Map<String, dynamic>> requestPostJson(String token, String url, Map<String, dynamic> data) async {
    dio.options.headers['Content-Type'] = 'application/json';
    if (token != "" || token != '') {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';

    try {
      final res = await dio.post(api, data: data, options: Options(validateStatus: (status) {
        return status != null && status < 500;
      }));
      if (res.statusCode == 200) {
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
    if (token != "" || token != '') {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';
    try {
      final res = await dio.put(api, data: data, options: Options(validateStatus: (status) {
        return status != null && status < 500;
      }));
      if (res.statusCode == 200) {
        return res.data;
      } else {
        logger.e("${res.statusCode} : ${res.statusMessage}s");
        return res.data;
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> requestDeleteJson(String token, String url) async {
    dio.options.headers['Content-Type'] = 'application/json';
    // dio.options.headers['Authorization'] = 'Bearer $token';
    final api = '$baseUrl$url';
    final res = await dio.delete(api);
    if (res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      return res.data;
    }
  }

  Future<Map<String, dynamic>> requestRegisterFormData(
      String token, String url, List<XFile> data, Map<String, dynamic> post) async {
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    if (token != "" || token != '') {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';

    final files = <MultipartFile>[];

    for (final image in data) {
      final fileName = basename(image.path);
      final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
      files.add(
        await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    final form = FormData.fromMap({
      'post': jsonEncode(post),
      'images': files,
    });

    final res = await dio.post(api, data: form, options: Options(validateStatus: (status) {
      return status != null && status < 500;
    }));

    if (res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      return res.data;
    }
  }

  Future<Map<String, dynamic>> requestUpdateFormData(
      String token, String url, Map<String, dynamic> post, List<XFile> data, List<Map<String, dynamic>> deleteImages) async {
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    if (token != "" || token != '') {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';

    final files = <MultipartFile>[];

    if (data.isNotEmpty) {
      for (final image in data) {
        final fileName = basename(image.path);
        final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
        files.add(
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }
    }
    final Map<String, dynamic> formData = {
      'post': jsonEncode(post),
    };
      formData['deleteImages'] = jsonEncode(deleteImages);
    if (files.isNotEmpty) {
      formData['images'] = files;
    }

    final form = FormData.fromMap(formData);

    final res = await dio.put(api, data: form, options: Options(validateStatus: (status) {
      return status != null && status < 500;
    }));

    if (res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      return res.data;
    }
  }

  Future<Map<String, dynamic>> requestImagesDeleteFormData(
      String token, String url, List<Map<String, dynamic>> data) async {
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    if (token != "" || token != '') {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final api = '$baseUrl$url';
    final form = FormData.fromMap({
      'deleteImages': data,
    });
    final res = await dio.delete(api, data: form, options: Options(validateStatus: (status) {
      return status != null && status < 500;
    }));

    if (res.statusCode == 200) {
      return res.data;
    } else {
      logger.e("${res.statusCode} : ${res.statusMessage}s");
      return res.data;
    }
  }
}
