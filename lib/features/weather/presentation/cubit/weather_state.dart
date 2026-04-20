import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  final WeatherEntity? weather;
  final DioException? error;

  const WeatherState({this.weather, this.error});

  @override
  List<Object?> get props => [weather, error];
}

class WeatherStateLoading extends WeatherState {
  const WeatherStateLoading() : super();
}

class WeatherStateLoaded extends WeatherState {
  const WeatherStateLoaded({required WeatherEntity weather})
    : super(weather: weather);
}

class WeatherStateError extends WeatherState {
  const WeatherStateError(DioException error) : super(error: error);
}
