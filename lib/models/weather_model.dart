class CurrentWeather {
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final String time;

  const CurrentWeather({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      time: json['time'] as String? ?? '',
    );
  }
}

class DailyForecastItem {
  final DateTime date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final int precipitationProbability;

  const DailyForecastItem({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbability,
  });
}

class DailyForecast {
  final List<DailyForecastItem> items;

  const DailyForecast({required this.items});

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final times = (json['time'] as List<dynamic>?) ?? [];
    final weatherCodes = (json['weather_code'] as List<dynamic>?) ?? [];
    final tempMaxs = (json['temperature_2m_max'] as List<dynamic>?) ?? [];
    final tempMins = (json['temperature_2m_min'] as List<dynamic>?) ?? [];
    final precipProbs = (json['precipitation_probability_max'] as List<dynamic>?) ?? [];

    final count = times.length;
    final List<DailyForecastItem> forecastList = [];

    for (int i = 0; i < count; i++) {
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(times[i].toString());
      } catch (_) {
        parsedDate = DateTime.now().add(Duration(days: i));
      }

      forecastList.add(
        DailyForecastItem(
          date: parsedDate,
          weatherCode: i < weatherCodes.length ? (weatherCodes[i] as num).toInt() : 0,
          tempMax: i < tempMaxs.length ? (tempMaxs[i] as num).toDouble() : 0.0,
          tempMin: i < tempMins.length ? (tempMins[i] as num).toDouble() : 0.0,
          precipitationProbability: i < precipProbs.length ? (precipProbs[i] as num).toInt() : 0,
        ),
      );
    }

    return DailyForecast(items: forecastList);
  }
}

class WeatherData {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final DailyForecast daily;

  const WeatherData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'auto',
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>? ?? {}),
      daily: DailyForecast.fromJson(json['daily'] as Map<String, dynamic>? ?? {}),
    );
  }
}
