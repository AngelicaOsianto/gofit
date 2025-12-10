import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
  // API Key kamu
>>>>>>> Stashed changes
=======
  // API Key kamu
>>>>>>> Stashed changes
=======
  // API Key kamu
>>>>>>> Stashed changes
  final String apiKey = '5ba238665cdce08a478c9c80d7c15aa0';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    try {
      final response = await http.get(url);
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    try {
      final response = await http.get(url);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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