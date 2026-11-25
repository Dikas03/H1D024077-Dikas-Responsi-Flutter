import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/local_storage_service.dart';
import 'services/weather_api_service.dart';
import 'utils/app_theme.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Service Dependencies
  final weatherApiService = WeatherApiService();
  final localStorageService = LocalStorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: weatherApiService,
            storageService: localStorageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            apiService: weatherApiService,
            storageService: localStorageService,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
