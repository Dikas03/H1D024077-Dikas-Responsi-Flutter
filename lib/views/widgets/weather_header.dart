import 'package:flutter/material.dart';
import '../../models/location_model.dart';
import '../../models/weather_model.dart';
import '../../utils/weather_code_helper.dart';

class WeatherHeader extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather current;

  const WeatherHeader({
    super.key,
    required this.location,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final condition = WeatherCodeHelper.getCondition(current.weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: condition.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: condition.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nama Kota dan Wilayah
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  location.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (location.country != null && location.country!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              location.admin1 != null && location.admin1 != location.name
                  ? '${location.admin1}, ${location.country}'
                  : location.country!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 20),

          // Ikon Cuaca
          Icon(
            condition.icon,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 12),

          // Suhu Saat Ini
          Text(
            '${current.temperature.toStringAsFixed(1)}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 68,
              fontWeight: FontWeight.w200,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),

          // Kondisi Cuaca
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              condition.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
