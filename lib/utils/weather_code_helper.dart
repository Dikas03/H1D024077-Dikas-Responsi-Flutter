import 'package:flutter/material.dart';

class WeatherCondition {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const WeatherCondition({
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class WeatherCodeHelper {
  /// Mengonversi WMO Weather Code dari Open-Meteo menjadi deskripsi, ikon, dan warna tema
  static WeatherCondition getCondition(int code) {
    switch (code) {
      case 0:
        return const WeatherCondition(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          gradientColors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
        );
      case 1:
        return const WeatherCondition(
          description: 'Cerah Berawan',
          icon: Icons.wb_cloudy_rounded,
          gradientColors: [Color(0xFF2980B9), Color(0xFF6DD5FA)],
        );
      case 2:
        return const WeatherCondition(
          description: 'Sebagian Berawan',
          icon: Icons.cloud_queue_rounded,
          gradientColors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],
        );
      case 3:
        return const WeatherCondition(
          description: 'Mendung Berawan',
          icon: Icons.cloud_rounded,
          gradientColors: [Color(0xFF4B6CB7), Color(0xFF182848)],
        );
      case 45:
      case 48:
        return const WeatherCondition(
          description: 'Berkabut',
          icon: Icons.blur_on_rounded,
          gradientColors: [Color(0xFF536976), Color(0xFF292E49)],
        );
      case 51:
      case 53:
      case 55:
        return const WeatherCondition(
          description: 'Gerimis',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF3E5151), Color(0xFFDEC79B)],
        );
      case 56:
      case 57:
        return const WeatherCondition(
          description: 'Gerimis Dingin',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
        );
      case 61:
        return const WeatherCondition(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_rounded,
          gradientColors: [Color(0xFF203A43), Color(0xFF2C5364)],
        );
      case 63:
        return const WeatherCondition(
          description: 'Hujan Sedang',
          icon: Icons.umbrella_rounded,
          gradientColors: [Color(0xFF1F4068), Color(0xFF162447)],
        );
      case 65:
        return const WeatherCondition(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF0F2027), Color(0xFF203A43)],
        );
      case 66:
      case 67:
        return const WeatherCondition(
          description: 'Hujan Beku',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF283048), Color(0xFF859398)],
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherCondition(
          description: 'Salju',
          icon: Icons.snowing,
          gradientColors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
        );
      case 80:
        return const WeatherCondition(
          description: 'Hujan Ringan Sesaat',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF283E51), Color(0xFF485563)],
        );
      case 81:
        return const WeatherCondition(
          description: 'Hujan Sedang Sesaat',
          icon: Icons.water_drop_rounded,
          gradientColors: [Color(0xFF1F4068), Color(0xFF162447)],
        );
      case 82:
        return const WeatherCondition(
          description: 'Hujan Deras Sesaat',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF0F2027), Color(0xFF203A43)],
        );
      case 85:
      case 86:
        return const WeatherCondition(
          description: 'Hujan Salju Sesaat',
          icon: Icons.snowing,
          gradientColors: [Color(0xFF3E5151), Color(0xFFDEC79B)],
        );
      case 95:
        return const WeatherCondition(
          description: 'Badai Petir',
          icon: Icons.flash_on_rounded,
          gradientColors: [Color(0xFF141E30), Color(0xFF243B55)],
        );
      case 96:
      case 99:
        return const WeatherCondition(
          description: 'Badai Petir & Es',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF0F2027), Color(0xFF203A43)],
        );
      default:
        return const WeatherCondition(
          description: 'Berawan',
          icon: Icons.cloud_rounded,
          gradientColors: [Color(0xFF2980B9), Color(0xFF6DD5FA)],
        );
    }
  }
}
