import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';
import 'package:blocnewsapp/core/resources/data_state.dart';

abstract class WeatherRepository {
  Future<DataState<WeatherEntity>> getCurrentWeather(String city);
}
