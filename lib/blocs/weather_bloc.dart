import 'package:bloc/bloc.dart';
import 'package:cityweather/blocs/weather_event.dart';
import 'package:cityweather/blocs/weather_state.dart';
import 'package:cityweather/weather_model.dart';
import 'package:cityweather/weather_repo.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepo weatherRepo;

  WeatherBloc(this.weatherRepo);

  @override
  // TODO: implement initialState
  WeatherState get initialState => CityNotSearched();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherIsLoading();

      try {
        WeatherModel weatherModel = await weatherRepo.getWeather(event.getCity);
        yield WeatherIsLoaded(weatherModel);
      } catch (_) {
        print(_);
        yield WeatherIsNotFetched();
      }
    } else if (event is ResetWeather) {
      yield CityNotSearched();
    }
  }
}
