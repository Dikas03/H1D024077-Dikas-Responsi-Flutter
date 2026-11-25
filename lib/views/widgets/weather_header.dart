import 'package:flutter/material.dart';
import '../../models/location_model.dart';
import '../../models/weather_model.dart';
import '../../utils/weather_code_helper.dart';
import 'glass_card.dart';

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

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      borderRadius: 30,
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      child: Column(
        children: [
          // Nama Kota dan Pin Lokasi
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  location.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (location.country != null && location.country!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              location.admin1 != null && location.admin1 != location.name
                  ? '${location.admin1}, ${location.country}'
                  : location.country!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),

          // Ikon Cuaca dengan Glow Efek
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: condition.gradientColors.first.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Icon(
              condition.icon,
              size: 84,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),

          // Suhu Saat Ini
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                current.temperature.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 76,
                  fontWeight: FontWeight.w200,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const Text(
                '°C',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Badge Kondisi Cuaca
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  condition.icon,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  condition.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
