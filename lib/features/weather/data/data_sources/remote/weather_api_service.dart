
import 'package:blocnewsapp/features/weather/data/models/weather.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'weather_api_service.g.dart';

@RestApi()
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio, {String? baseUrl}) = _WeatherApiService;

  @GET("/weather/current")
  Future<HttpResponse<WeatherModel>> getCurrentWeather({
    @Query("city") String ? city,
    @Query("units") String ? units,
  });
}