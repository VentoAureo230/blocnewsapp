import 'dart:io';

import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/core/util/api_error_handler.dart';
import 'package:blocnewsapp/features/weather/data/data_sources/remote/weather_api_service.dart';
import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';
import 'package:blocnewsapp/features/weather/domain/repository/weather_repository.dart';
import 'package:dio/dio.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _weatherApiService;
  final ApiErrorHandler _apiErrorHandler = const ApiErrorHandler();

  WeatherRepositoryImpl(this._weatherApiService);

  @override
  Future<DataState<WeatherEntity>> getCurrentWeather(String city) async {
    try {
      final httpResponse = await _weatherApiService.getCurrentWeather(
        city: city,
        // units: weatherUnits,
      );
      
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(_apiErrorHandler.fromResponse(httpResponse.response));
      }
    } on DioException catch (e) {
      return DataFailed(_apiErrorHandler.handle(e));
    }
  }
}