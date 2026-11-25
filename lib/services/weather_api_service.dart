import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';

  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari daftar lokasi berdasarkan query nama kota menggunakan Open-Meteo Geocoding API
  Future<List<LocationModel>> searchLocation(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      '$_geocodingBaseUrl?name=${Uri.encodeComponent(query.trim())}&count=10&language=id&format=json',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final List<dynamic> results = data['results'];
          return results.map((item) => LocationModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw Exception('Gagal mencari lokasi. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Waktu koneksi habis. Silakan coba lagi.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan saat mencari lokasi: $e');
    }
  }

  /// Mengambil data cuaca terkini dan prakiraan harian berdasarkan koordinat latitude & longitude
  Future<WeatherData> getWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    final queryParams = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
    };

    final uri = Uri.parse(_forecastBaseUrl).replace(queryParameters: queryParams);

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Gagal memuat cuaca. Server merespons: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Waktu permintaan data cuaca habis. Silakan coba lagi.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan saat memuat cuaca: $e');
    }
  }
}
