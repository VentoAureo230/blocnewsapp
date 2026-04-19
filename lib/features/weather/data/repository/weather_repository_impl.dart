import 'dart:io';

import 'package:blocnewsapp/core/constants/constants.dart';
import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/weather/data/data_sources/remote/weather_api_service.dart';
import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';
import 'package:blocnewsapp/features/weather/domain/repository/weather_repository.dart';
import 'package:dio/dio.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _weatherApiService;

  WeatherRepositoryImpl(this._weatherApiService);

  @override
  Future<DataState<WeatherEntity>> getCurrentWeather(String city) async {
    try {
      final httpResponse = await _weatherApiService.getCurrentWeather(
        city: city,
        apiKey: weatherApiKey,
        // units: weatherUnits,
      );
      
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}