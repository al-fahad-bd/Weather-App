// import '../consts/strings.dart';
// import 'package:http/http.dart' as http;

// import '../models/current_weather_model.dart';
// import '../models/hourly_weather_model.dart';
// import '../models/weather_model.dart';

// getCurrentWeather(lat, long) async {
//   var link =
//       "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
//   var res = await http.get(Uri.parse(link));
//   if (res.statusCode == 200) {
//     var data = currentWeatherDataFromJson(res.body.toString());

//     return data;
//   }
// }

// getHourlyWeather(lat, long) async {
//   var link =
//       "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
//   var res = await http.get(Uri.parse(link));
//   if (res.statusCode == 200) {
//     var data = hourlyWeatherDataFromJson(res.body.toString());

//     return data;
//   }
// }

// getWeather(lat, long) async {
//   var link =
//       "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&exclude=minutely&appid=$apiKey&units=metric";
//   var res = await http.get(Uri.parse(link));
//   if (res.statusCode == 200) {
//     var data = weatherDataFromJson(res.body.toString());

//     return data;
//   }
// }

import 'package:flutter/material.dart';

import '../consts/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON decoding and error

import '../models/current_weather_model.dart';
import '../models/hourly_weather_model.dart';
import '../models/weather_model.dart';

getCurrentWeather(lat, long) async {
  var link =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  try {
    var res = await http.get(Uri.parse(link));

    if (res.statusCode == 200) {
      var data = currentWeatherDataFromJson(res.body.toString());
      return data;
    } else {
      return Future.error("Error: ${res.body}");
    }
  } catch (e) {
    return Future.error("Exception: $e");
  }
}

getHourlyWeather(lat, long) async {
  var link =
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  try {
    var res = await http.get(Uri.parse(link));

    if (res.statusCode == 200) {
      var data = hourlyWeatherDataFromJson(res.body.toString());
      return data;
    } else {
      return Future.error("Error: ${res.body}");
    }
  } catch (e) {
    return Future.error("Exception: $e");
  }
}

getWeather(lat, long) async {
  var link =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&exclude=minutely&appid=$apiKey&units=metric";
  try {
    var res = await http.get(Uri.parse(link));

    if (res.statusCode == 200) {
      var data = weatherDataFromJson(res.body.toString());
      return data;
    } else {
      return Future.error("Error: ${res.body}");
    }
  } catch (e) {
    return Future.error("Exception: $e");
  }
}
