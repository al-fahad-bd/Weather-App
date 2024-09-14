import 'dart:convert';

// Method to convert from JSON string to model
CurrentWeatherData currentWeatherDataFromJson(String str) =>
    CurrentWeatherData.fromJson(json.decode(str));

// Method to convert from model to JSON string
String currentWeatherDataToJson(CurrentWeatherData data) =>
    json.encode(data.toJson());

// CurrentWeatherData model
class CurrentWeatherData {
  CurrentWeatherData({
    this.weather,
    this.main,
    this.wind,
    this.clouds,
    this.dt,
    this.name,
  });

  List<Weather>? weather;
  Main? main;
  Wind? wind;
  Clouds? clouds;
  int? dt;
  String? name;

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) =>
      CurrentWeatherData(
        weather: json["weather"] != null
            ? List<Weather>.from(
                json["weather"].map((x) => Weather.fromJson(x)))
            : [],
        main: json["main"] != null ? Main.fromJson(json["main"]) : null,
        wind: json["wind"] != null ? Wind.fromJson(json["wind"]) : null,
        clouds: json["clouds"] != null ? Clouds.fromJson(json["clouds"]) : null,
        dt: json["dt"] ?? 0,
        name: json["name"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() => {
        "weather": weather?.map((x) => x.toJson()).toList(),
        "main": main?.toJson(),
        "wind": wind?.toJson(),
        "clouds": clouds?.toJson(),
        "dt": dt,
        "name": name,
      };
}

// Clouds model
class Clouds {
  Clouds({this.all});

  int? all;

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

// Main model
class Main {
  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.humidity,
  });

  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? humidity;

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: (json["temp"] ?? 0).toDouble(),
        feelsLike: (json["feels_like"] ?? 0).toDouble(),
        tempMin: (json["temp_min"] ?? 0).toDouble(),
        tempMax: (json["temp_max"] ?? 0).toDouble(),
        humidity: json["humidity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "humidity": humidity,
      };
}

// Weather model
class Weather {
  Weather({this.main, this.icon});

  String? main;
  String? icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        main: json["main"] ?? "Clear",
        icon: json["icon"] ?? "01d",
      );

  Map<String, dynamic> toJson() => {
        "main": main,
        "icon": icon,
      };
}

// Wind model
class Wind {
  Wind({this.speed, this.deg});

  double? speed;
  int? deg;

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: (json["speed"] ?? 0).toDouble(),
        deg: json["deg"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
      };
}
