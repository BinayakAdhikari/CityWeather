import 'package:equatable/equatable.dart';

class WeatherEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final _city;

  FetchWeather(this._city);

  String get getCity => _city;

  @override
  // TODO: implement props
  List<Object> get props => [_city];
}

class ResetWeather extends WeatherEvent {}
