import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class WeatherCard extends StatelessWidget {
  String day = "";

  void setDay(String d) {
    day = d;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        decoration: const BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(blurRadius: 10,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(0, 5))
            ],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        height: 200,
        width: 380,
        child: Center(child: Row(children: [
          Container(margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text('$day', style: TextStyle(color: Colors.white, fontSize: 48)))
        ])));
  }
}

class _MyAppState extends State<MyApp> {

  late List<Widget> weatherCards;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My App',
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Center(child: Text("Weather App")),
          ),
          body: SafeArea(
            child: Container(
                color: const Color.fromRGBO(0, 153, 248, 0.45098039215686274),
                child: RefreshIndicator(
                  onRefresh: pullToRefresh,
                  child:SingleChildScrollView(
                      child: Center(
                          child:Container(
                              margin: const EdgeInsets.only(top: 15),
                              child:Column(
                                  children: buildWeatherDayCardList())))),
                )),
          ),
        )
    );
  }

  Future<void> pullToRefresh() async {
    fetchWeatherData();
  }

  Widget buildWeatherDayCard() {
    return WeatherCard();
  }

  void fetchWeatherData() async {
    final url = Uri.parse("https://api.weather.gov/gridpoints/ILX/62,90/forecast");
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    final properties = json["properties"];
    final periods = properties["periods"];
    List<dynamic> list = List.from(periods);



    setState(() {
      for(int i=0; i<7; i++) {
        final weatherCard = weatherCards[i] as WeatherCard;
        final period = list[i];
        final day = period["name"];
        final temp = period["temperature"];
        final tempUnit = period["temperatureUnit"];
        final shortForecast = period["shortForecast"];
        final iconUrl = period["icon"];
        weatherCard.setDay(day);
        weatherCards[i] = weatherCard;

        print(day);
        print(temp);
      }
    });
  }

  List<Widget> buildWeatherDayCardList() {
    weatherCards = [
      buildWeatherDayCard(),
      buildWeatherDayCard(),
      buildWeatherDayCard(),
      buildWeatherDayCard(),
      buildWeatherDayCard(),
      buildWeatherDayCard(),
      buildWeatherDayCard(),
    ];

    return weatherCards;
  }

}
