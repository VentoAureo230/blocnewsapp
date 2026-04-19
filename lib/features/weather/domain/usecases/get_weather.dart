import 'package:blocnewsapp/core/usecases/usecase.dart';
import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';
import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/weather/domain/repository/weather_repository.dart';

class GetWeatherUseCase implements Usecase<DataState<WeatherEntity>, String> {
  final WeatherRepository _weatherRepository;
  GetWeatherUseCase(this._weatherRepository);
  
  @override
  Future<DataState<WeatherEntity>> call({String? params}) {
    return _weatherRepository.getCurrentWeather(params ?? '');
  }
  
}