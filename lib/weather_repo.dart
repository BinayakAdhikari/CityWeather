import 'dart:convert';

import 'package:cityweather/constants.dart';
import 'package:cityweather/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherRepo {
  Future<WeatherModel> getWeather(String city) async {
    final result = await http
        .get("${Constants.apiEndpoint}?q=$city&APPID=${Constants.apiKey}");
    if (result.statusCode != 200) {
      throw Exception();
    }
    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final response) {
    final decodedJson = json.decode(response);
    final jsonWeather = decodedJson['main'];

    return WeatherModel.fromJson(jsonWeather);
  }
}
