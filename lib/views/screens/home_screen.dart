import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../widgets/animated_weather_background.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/error_view.dart';
import '../widgets/weather_details_card.dart';
import '../widgets/weather_header.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, weatherVM, child) {
        final weatherData = weatherVM.weatherData;
        final weatherCode = weatherData?.current.weatherCode ?? 1;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Info Cuaca',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 1)),
                ],
              ),
            ),
            actions: [
              // Tombol Tambah/Hapus Favorit Kota Saat Ini
              IconButton(
                icon: Icon(
                  weatherVM.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: weatherVM.isFavorite ? Colors.redAccent : Colors.white,
                  size: 26,
                ),
                tooltip: weatherVM.isFavorite ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
                onPressed: () {
                  weatherVM.toggleFavorite();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        weatherVM.isFavorite
                            ? '${weatherVM.currentLocation.name} ditambahkan ke Favorit'
                            : '${weatherVM.currentLocation.name} dihapus dari Favorit',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              // Tombol Buka Search / Location Screen
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                tooltip: 'Cari Kota',
                onPressed: () async {
                  final selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );

                  if (selectedLocation != null && context.mounted) {
                    weatherVM.selectLocation(selectedLocation);
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: AnimatedWeatherBackground(
            weatherCode: weatherCode,
            child: SafeArea(
              child: _buildBody(weatherVM),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(WeatherViewModel weatherVM) {
    // 1. Kondisi Loading
    if (weatherVM.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 18),
            Text(
              'Mengambil data cuaca terkini...',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // 2. Kondisi Error
    if (weatherVM.hasError) {
      return ErrorView(
        message: weatherVM.errorMessage ?? 'Gagal memuat cuaca.',
        onRetry: () => weatherVM.fetchWeather(),
      );
    }

    // 3. Kondisi Data Kosong
    final weatherData = weatherVM.weatherData;
    if (weatherData == null) {
      return const Center(
        child: Text(
          'Data cuaca tidak tersedia.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    // 4. Tampilan Utama Cuaca
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF1B629B),
      onRefresh: () => weatherVM.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Cuaca (Kota, Suhu Saat Ini, Ikon Bercahaya, Badge Kondisi)
            WeatherHeader(
              location: weatherVM.currentLocation,
              current: weatherData.current,
            ),
            const SizedBox(height: 22),

            // Kartu Detail Cuaca Frosted-Glass (Kelembapan, Angin, Suhu Terasa, Curah Hujan)
            WeatherDetailsCard(
              current: weatherData.current,
            ),
            const SizedBox(height: 24),

            // Perkiraan Cuaca Harian 7 Hari ke Depan
            DailyForecastCard(
              daily: weatherData.daily,
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
