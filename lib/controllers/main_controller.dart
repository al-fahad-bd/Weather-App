import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../models/current_weather_model.dart';
import '../models/hourly_weather_model.dart';
import '../services/api_services.dart';

class MainController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    
    await getUserLocation(); // Wait for user location
    await fetchWeatherData(); // Fetch weather data after getting location
  }

  // Fetch weather data and update relevant variables
  Future<void> fetchWeatherData() async {
    try {
      // Fetch current weather
      currentWeatherData = await getCurrentWeather(latitude.value, longitude.value);
      if (currentWeatherData == null) {
        throw Exception("Failed to fetch current weather data");
      }

      // Fetch hourly weather
      hourlyWeatherData = await getHourlyWeather(latitude.value, longitude.value);
      if (hourlyWeatherData == null) {
        throw Exception("Failed to fetch hourly weather data");
      }

      // Fetch one call weather data (if applicable)
      weatherData = await getWeather(latitude.value, longitude.value);
      if (weatherData == null) {
        throw Exception("Failed to fetch one call weather data");
      }

      // Fetch address
      address = await getAddress(latitude.value, longitude.value);
      if (address == null) {
        throw Exception("Failed to fetch address");
      }

      // Set data loaded flag
      isloaded.value = true;

    } catch (e) {
      // Handle errors gracefully
       return null;
    }
  }

  // Get address based on coordinates
  Future<String?> getAddress(lat, long) async {
    try {
      List<Placemark> placeMark = await placemarkFromCoordinates(lat, long);
      Placemark place = placeMark[0];
      var city = place.subLocality;
      return city;
    } catch (e) {
      return null;
    }
  }

  var isDark = true.obs;
  dynamic currentWeatherData;
  dynamic hourlyWeatherData;
  dynamic weatherData;
  dynamic address;
  dynamic address2;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isloaded = false.obs;

  // Method to change theme
  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Get user location and update latitude and longitude
  Future<void> getUserLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return Future.error("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).then((position) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    }).catchError((e) {
      return null;
    });
  }
}
