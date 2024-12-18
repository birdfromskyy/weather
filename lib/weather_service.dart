import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '4e0cc044342848a9919122841241412';
  final String baseUrl = 'https://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$city&aqi=no'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Не удалось загрузить данные о погоде');
    }
  }

  Future<Map<String, dynamic>> fetchForecast(String city) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast.json?key=$apiKey&q=$city&days=10&aqi=no&alerts=no'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Не удалось загрузить данные о прогнозе');
    }
  }
}
