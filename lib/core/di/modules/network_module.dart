import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wasel_task/core/network/api_service_new.dart';
import 'package:wasel_task/core/network/http_client_wrapper.dart';

abstract class NetworkModule {
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: 'https://dummyjson.com',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      )..interceptors.add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));

  GoogleSignIn get googleSignIn => GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );
      
  ApiService apiService(HttpClientWrapper httpClientWrapper) => ApiService(httpClientWrapper);
}
