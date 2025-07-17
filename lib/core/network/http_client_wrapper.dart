import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wasel_task/core/error/exceptions.dart';

class HttpClientWrapper {
  final String baseUrl;
  final http.Client _client;
  final Map<String, String> _headers;

  HttpClientWrapper({
    required this.baseUrl,
    http.Client? client,
    Map<String, String>? headers,
  })  : _client = client ?? http.Client(),
        _headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        };

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = Uri.parse('$baseUrl$path')
          .replace(queryParameters: _stringifyQueryParams(queryParameters));
      
      final response = await _client.get(
        uri,
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Failed to perform GET request: $e');
    }
  }

  Future<dynamic> post(String path, {dynamic body}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Failed to perform POST request: $e');
    }
  }

  Future<dynamic> put(String path, {dynamic body}) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Failed to perform PUT request: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Failed to perform DELETE request: $e');
    }
  }

  void close() {
    _client.close();
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw ServerException(
        'Request failed with status: $statusCode',
        statusCode: statusCode,
        data: responseBody,
      );
    }
  }

  Map<String, String> _stringifyQueryParams(Map<String, dynamic>? params) {
    if (params == null) return {};
    return params.map((key, value) => MapEntry(key, value.toString()));
  }
}
