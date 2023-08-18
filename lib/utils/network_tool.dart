// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/auth_controller.dart';
import '../env/env.dart';

enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
}

class ApiHelper {
  final AppUserController _authController = Get.find();

  Future<http.Response> sendRequest(
    HttpMethod method,
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
  }) async {
    final uri = Uri.https(
      Env.awsApiGw,
      path,
      queryParams,
    );

    final token = await _authController.getCognitoAccessToken();

    final requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
      'accept': 'application/json',
      'Authorization': token,
      ...?headers,
    };

    final sanitizedHeaders =
        requestHeaders.map((key, value) => MapEntry(key, value ?? ''));

    late http.Response response;

    switch (method) {
      case HttpMethod.GET:
        response = await http.get(uri, headers: sanitizedHeaders);
        break;
      case HttpMethod.POST:
        response = await http.post(uri, headers: sanitizedHeaders, body: body);
        break;
      case HttpMethod.PUT:
        response = await http.put(uri, headers: sanitizedHeaders, body: body);
        break;
      case HttpMethod.DELETE:
        response = await http.delete(uri, headers: sanitizedHeaders);
        break;
    }

    return response;
  }
}
