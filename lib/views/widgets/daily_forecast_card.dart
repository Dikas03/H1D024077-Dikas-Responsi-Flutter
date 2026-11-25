import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_model.dart';
import '../../utils/weather_code_helper.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecast daily;

  const DailyForecastCard({
    super.key,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perkiraan Cuaca 7 Hari ke Depan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2230) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daily.items.length,
            separatorBuilder: (context, index) => Divider(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
              height: 16,
            ),
            itemBuilder: (context, index) {
              final item = daily.items[index];
              final condition = WeatherCodeHelper.getCondition(item.weatherCode);

              // Penamaan Hari
              String dayLabel;
              final now = DateTime.now();
              if (item.date.year == now.year &&
                  item.date.month == now.month &&
                  item.date.day == now.day) {
                dayLabel = 'Hari Ini';
              } else if (item.date.difference(DateTime(now.year, now.month, now.day)).inDays == 1) {
                dayLabel = 'Besok';
              } else {
                try {
                  dayLabel = DateFormat('EEE, d MMM').format(item.date);
                } catch (_) {
                  dayLabel = '${item.date.day}/${item.date.month}';
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    // Label Tanggal/Hari
                    SizedBox(
                      width: 105,
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Ikon Cuaca & Deskripsi Singkat
                    Icon(
                      condition.icon,
                      color: condition.gradientColors.first,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        condition.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Peluang Hujan
                    if (item.precipitationProbability > 0)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 12,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${item.precipitationProbability}%',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Suhu Maksimum / Minimum
                    Text(
                      '${item.tempMax.round()}°',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.tempMin.round()}°',
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
