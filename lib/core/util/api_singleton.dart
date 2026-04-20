import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

/// A singleton class that initializes the Dio client and API URL.
class ApiSingleton {
  static final ApiSingleton _singleton = ApiSingleton._internal();

  Dio? client;
  String? apiUrl;
  String? environment;
  bool initialized = false;

  factory ApiSingleton() {
    return _singleton;
  }

  ApiSingleton._internal();

  Future<void> init() async {
    if (initialized) {
      return;
    }

    // Set the API URL based on the platform (dev issue)
    apiUrl = Platform.isIOS
        ? dotenv.env['API_URL_IOS']
        : dotenv.env['API_URL_ANDROID'];
    client = Dio(BaseOptions(baseUrl: apiUrl!));
    initialized = true;
  }
}
