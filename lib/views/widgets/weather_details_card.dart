import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

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
        const Text(
          'Detail Cuaca Hari Ini',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                context,
                icon: Icons.thermostat_rounded,
                iconColor: Colors.deepOrangeAccent,
                label: 'Suhu Terasa',
                value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailItem(
                context,
                icon: Icons.water_drop_rounded,
                iconColor: Colors.blueAccent,
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
              child: _buildDetailItem(
                context,
                icon: Icons.air_rounded,
                iconColor: Colors.teal,
                label: 'Kecepatan Angin',
                value: '${current.windSpeed.toStringAsFixed(1)} km/h',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailItem(
                context,
                icon: Icons.cloudy_snowing,
                iconColor: Colors.indigoAccent,
                label: 'Curah Hujan',
                value: '${current.precipitation.toStringAsFixed(1)} mm',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
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
                    color: isDark ? Colors.white60 : const Color(0xFF758A99),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
