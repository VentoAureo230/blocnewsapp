
import 'package:blocnewsapp/features/weather/data/models/weather.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'weather_api_service.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio) = _WeatherApiService;

  @GET("/weather")
  Future<HttpResponse<WeatherModel>> getCurrentWeather({
    @Query("q") String ? city,
    @Query("appid") String ? apiKey,
    @Query("units") String ? units,
  });
}