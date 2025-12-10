class WeatherModel {
  final String cityName;
  final double temperature;
  final String description; // Contoh: "rainy", "cloudy"
  final String iconCode;    // Kode icon dari API (misal: "10d")

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}