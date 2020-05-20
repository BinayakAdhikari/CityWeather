import 'package:cityweather/blocs/weather_bloc.dart';
import 'package:cityweather/blocs/weather_event.dart';
import 'package:cityweather/blocs/weather_state.dart';
import 'package:cityweather/weather_model.dart';
import 'package:cityweather/weather_repo.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: BlocProvider(
          builder: (context) => WeatherBloc(WeatherRepo()),
          child: SearchPage(),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            child: FlareActor('assets/WorldSpin.flr',
                fit: BoxFit.contain, animation: 'roll'),
            height: 300,
            width: 300,
          ),
        ),
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is CityNotSearched) {
              return Container(
                padding: EdgeInsets.only(
                  left: 32,
                  right: 32,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Search Weather",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                    Text(
                      "Instantly",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w200,
                          color: Colors.white70),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.white70,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue, style: BorderStyle.solid)),
                        hintText: "Enter City Name",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else if (state is WeatherIsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WeatherIsLoaded) {
              return ShowWeather(
                  state.getWeather, cityController.text, weatherBloc);
            } else {
              return Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Error',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(ResetWeather());
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          "Return Back",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  WeatherBloc weatherBloc;
  final city;

  ShowWeather(this.weather, this.city, this.weatherBloc);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(
              city,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weather.getTemp.round().toString() + "°C",
              style: TextStyle(color: Colors.white70, fontSize: 50),
            ),
            Text(
              "Temperature",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weather.getMinTemp.round().toString() + "°C",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Min Temperature",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      weather.getMaxTemp.round().toString() + "°C",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Max Temperature",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              weather.getFeelsLike.round().toString() + "°C",
              style: TextStyle(color: Colors.white70, fontSize: 30),
            ),
            Text(
              "Feels Like",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weather.humidity.round().toString(),
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    Text(
                      "Humidity",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      weather.pressure.round().toString(),
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    Text(
                      "Pressure",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  weatherBloc.add(ResetWeather());
                },
                color: Colors.lightBlue,
                child: Text(
                  "Return Back",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}