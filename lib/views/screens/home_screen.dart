import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/weather_viewmodel.dart';
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
    // Inisialisasi data cuaca setelah frame pertama selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, weatherVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Info Cuaca',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              // Tombol Tambah/Hapus Favorit Kota Saat Ini
              IconButton(
                icon: Icon(
                  weatherVM.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: weatherVM.isFavorite ? Colors.redAccent : null,
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
                icon: const Icon(Icons.search_rounded),
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
            ],
          ),
          body: _buildBody(weatherVM),
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
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Mengambil data cuaca terkini...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
        child: Text('Data cuaca tidak tersedia.'),
      );
    }

    // 4. Kondisi Sukses Memuat Data Cuaca
    return RefreshIndicator(
      onRefresh: () => weatherVM.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Cuaca (Kota, Suhu Saat Ini, Kondisi, Ikon)
            WeatherHeader(
              location: weatherVM.currentLocation,
              current: weatherData.current,
            ),
            const SizedBox(height: 20),

            // Kartu Detail Cuaca (Kelembapan, Angin, Suhu Terasa, Curah Hujan)
            WeatherDetailsCard(
              current: weatherData.current,
            ),
            const SizedBox(height: 24),

            // Perkiraan Cuaca Harian (7 Hari ke Depan)
            DailyForecastCard(
              daily: weatherData.daily,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
