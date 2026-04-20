import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/weather/domain/usecases/get_weather.dart';
import 'package:blocnewsapp/features/weather/presentation/cubit/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherUseCase _getWeatherUseCase;
  WeatherCubit(this._getWeatherUseCase) : super(const WeatherStateLoading());

  Future<void> getWeather(String city) async {
    emit(const WeatherStateLoading());
    final dataState = await _getWeatherUseCase(params: city);

    if (dataState is DataSuccess) {
      emit(WeatherStateLoaded(weather: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(WeatherStateError(dataState.error!));
    }
  }
}
