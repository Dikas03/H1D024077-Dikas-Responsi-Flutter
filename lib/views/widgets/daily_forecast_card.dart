import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_model.dart';
import '../../utils/weather_code_helper.dart';
import 'glass_card.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecast daily;

  const DailyForecastCard({
    super.key,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Perkiraan Cuaca 7 Hari ke Depan',
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
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          borderRadius: 24,
          backgroundColor: Colors.white.withValues(alpha: 0.12),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daily.items.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withValues(alpha: 0.15),
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
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Ikon Cuaca & Deskripsi Singkat
                    Icon(
                      condition.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        condition.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Peluang Hujan
                    if (item.precipitationProbability > 0)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.lightBlueAccent.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 12,
                              color: Colors.lightBlueAccent,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${item.precipitationProbability}%',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
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
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${item.tempMin.round()}°',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
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
