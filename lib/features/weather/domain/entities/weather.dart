import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String? cityName;
  final double? temperature;
  final String? description;
  final String? icon;

  const WeatherEntity({
    this.cityName,
    this.temperature,
    this.description,
    this.icon,
  });

  @override
  List<Object?> get props => [cityName, temperature, description, icon];
}
