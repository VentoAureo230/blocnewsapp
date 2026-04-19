import 'package:blocnewsapp/features/weather/domain/entities/weather.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    super.cityName,
    super.temperature,
    super.description,
    super.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['name'] as String?,
      temperature: map['main']['temp'] as double?,
      description: map['weather']['0']['description'] as String?,
      icon: map['weather']['0']['icon'] as String?,
    );
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['cityName'] as String?,
      temperature: map[''] as double?,
      description: map[''] as String?,
      icon: map[''] as String?,
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
