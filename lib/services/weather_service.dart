//Ambil data cuaca

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Minta API KEY ini ke Anggota C (Dia yang daftar OpenWeatherMap)
  // Sementara pakai dummy key atau kosongkan dulu
  final String apiKey = '5ba238665cdce08a478c9c80d7c15aa0';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric&lang=id'),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat cuaca');
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '5ba238665cdce08a478c9c80d7c15aa0';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat cuaca');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}