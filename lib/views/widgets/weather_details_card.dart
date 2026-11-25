import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import 'glass_card.dart';

class WeatherDetailsCard extends StatelessWidget {
  final CurrentWeather current;

  const WeatherDetailsCard({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Detail Cuaca Hari Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailGlassItem(
                icon: Icons.thermostat_rounded,
                iconColor: Colors.deepOrangeAccent,
                label: 'Suhu Terasa',
                value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailGlassItem(
                icon: Icons.water_drop_rounded,
                iconColor: Colors.lightBlueAccent,
                label: 'Kelembapan',
                value: '${current.relativeHumidity}%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailGlassItem(
                icon: Icons.air_rounded,
                iconColor: Colors.tealAccent,
                label: 'Kecepatan Angin',
                value: '${current.windSpeed.toStringAsFixed(1)} km/h',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailGlassItem(
                icon: Icons.cloudy_snowing,
                iconColor: Colors.cyanAccent,
                label: 'Curah Hujan',
                value: '${current.precipitation.toStringAsFixed(1)} mm',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailGlassItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      borderRadius: 20,
      backgroundColor: Colors.white.withValues(alpha: 0.12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
