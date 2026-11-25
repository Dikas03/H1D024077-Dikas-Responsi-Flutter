import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/models/weather_model.dart';
import 'package:responsi_flutter/utils/weather_code_helper.dart';

void main() {
  group('LocationModel Test', () {
    test('JSON serialization & deserialization', () {
      final json = {
        'id': 1642911,
        'name': 'Jakarta',
        'latitude': -6.21462,
        'longitude': 106.84513,
        'country': 'Indonesia',
        'admin1': 'Jakarta',
        'timezone': 'Asia/Jakarta',
      };

      final location = LocationModel.fromJson(json);
      expect(location.name, 'Jakarta');
      expect(location.latitude, -6.21462);
      expect(location.longitude, 106.84513);
      expect(location.country, 'Indonesia');

      final serialized = location.toJson();
      expect(serialized['id'], 1642911);
      expect(serialized['name'], 'Jakarta');
    });

    test('fullAddress formatting', () {
      const loc = LocationModel(
        id: 1,
        name: 'Bandung',
        latitude: -6.9175,
        longitude: 107.6191,
        country: 'Indonesia',
        admin1: 'Jawa Barat',
      );

      expect(loc.fullAddress, 'Bandung, Jawa Barat, Indonesia');
    });
  });

  group('WeatherModel Test', () {
    test('CurrentWeather and DailyForecast parsing', () {
      final rawJson = {
        'latitude': -6.2,
        'longitude': 106.8,
        'timezone': 'Asia/Jakarta',
        'current': {
          'temperature_2m': 28.5,
          'relative_humidity_2m': 80,
          'apparent_temperature': 33.2,
          'precipitation': 1.5,
          'weather_code': 61,
          'wind_speed_10m': 12.0,
          'time': '2026-11-25T12:00',
        },
        'daily': {
          'time': ['2026-11-25'],
          'weather_code': [61],
          'temperature_2m_max': [31.0],
          'temperature_2m_min': [24.0],
          'precipitation_probability_max': [75],
        },
      };

      final weatherData = WeatherData.fromJson(rawJson);
      expect(weatherData.current.temperature, 28.5);
      expect(weatherData.current.relativeHumidity, 80);
      expect(weatherData.current.precipitation, 1.5);
      expect(weatherData.current.windSpeed, 12.0);
      expect(weatherData.daily.items.length, 1);
      expect(weatherData.daily.items.first.tempMax, 31.0);
      expect(weatherData.daily.items.first.precipitationProbability, 75);
    });
  });

  group('WeatherCodeHelper Test', () {
    test('WMO code resolution', () {
      final sunny = WeatherCodeHelper.getCondition(0);
      expect(sunny.description, 'Cerah');

      final rain = WeatherCodeHelper.getCondition(61);
      expect(rain.description, 'Hujan Ringan');

      final thunder = WeatherCodeHelper.getCondition(95);
      expect(thunder.description, 'Badai Petir');
    });
  });
}
