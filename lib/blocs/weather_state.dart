import 'package:cityweather/weather_model.dart';
import 'package:equatable/equatable.dart';

class WeatherState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CityNotSearched extends WeatherState {}

class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final _weather;

  WeatherIsLoaded(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  // TODO: implement props
  List<Object> get props => [_weather];
}

class WeatherIsNotFetched extends WeatherState {}
