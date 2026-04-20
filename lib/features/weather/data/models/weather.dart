import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    super.cityName,
    super.temperature,
    super.description,
    super.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> map) {
    final weatherList = map['weather'] as List<dynamic>?;
    final firstWeather = weatherList != null && weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : null;
    return WeatherModel(
      cityName: map['name'] as String?,
      temperature: (map['main']['temp'] as num?)?.toDouble(),
      description: firstWeather?['description'] as String?,
      icon: firstWeather?['icon'] as String?,
    );
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['cityName'] as String?,
      temperature: (map['temperature'] as num?)?.toDouble(),
      description: map['description'] as String?,
      icon: map['icon'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
      'icon': icon,
    };
  }

  factory WeatherModel.fromEntity(WeatherEntity entity) {
    return WeatherModel(
      cityName: entity.cityName,
      temperature: entity.temperature,
      description: entity.description,
      icon: entity.icon,
    );
  }
}
