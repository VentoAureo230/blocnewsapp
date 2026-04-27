import 'dart:io';

import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/core/util/api_error_handler.dart';
import 'package:blocnewsapp/features/authentication/data/data_sources/local/authentication_local_storage.dart';
import 'package:blocnewsapp/features/authentication/data/data_sources/remote/authentication_api_service.dart';
import 'package:blocnewsapp/features/authentication/data/models/authentication.dart';
import 'package:blocnewsapp/features/authentication/domain/repository/authentication_repository.dart';
import 'package:dio/dio.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationApiService _authenticationApiService;
  final AuthenticationLocalStorage _authenticationLocalStorage;
  final ApiErrorHandler _apiErrorHandler = const ApiErrorHandler();

  AuthenticationRepositoryImpl(
    this._authenticationApiService,
    this._authenticationLocalStorage,
  );

  @override
  Future<DataState<AuthenticationModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final httpResponse = await _authenticationApiService.login(
        email: email,
        password: password,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        final token = httpResponse.data.token;
        if (token != null && token.isNotEmpty) {
          await _authenticationLocalStorage.saveToken(token);
        }
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(_apiErrorHandler.fromResponse(httpResponse.response));
      }
    } on DioException catch (e) {
      return DataFailed(_apiErrorHandler.handle(e));
    }
  }

  @override
  Future<DataState<AuthenticationModel>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final httpResponse = await _authenticationApiService.register(
        username: username,
        email: email,
        password: password,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        final token = httpResponse.data.token;
        if (token != null && token.isNotEmpty) {
          await _authenticationLocalStorage.saveToken(token);
        }
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(_apiErrorHandler.fromResponse(httpResponse.response));
      }
    } on DioException catch (e) {
      return DataFailed(_apiErrorHandler.handle(e));
    }
  }

  @override
  Future<String?> getStoredToken() {
    return _authenticationLocalStorage.getToken();
  }

  @override
  Future<void> clearStoredToken() {
    return _authenticationLocalStorage.clearToken();
  }
}
