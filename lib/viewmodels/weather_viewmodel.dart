import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

enum WeatherViewState { initial, loading, loaded, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  WeatherViewState _state = WeatherViewState.initial;
  WeatherViewState get state => _state;

  LocationModel _currentLocation = LocationModel.defaultLocation;
  LocationModel get currentLocation => _currentLocation;

  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  bool get isLoading => _state == WeatherViewState.loading;
  bool get hasError => _state == WeatherViewState.error;
  bool get hasData => _state == WeatherViewState.loaded && _weatherData != null;

  /// Inisialisasi awal saat aplikasi dibuka: mengambil lokasi terakhir dan memuat cuaca
  Future<void> initialize() async {
    _currentLocation = await _storageService.getLastLocation();
    await _checkFavoriteStatus();
    await fetchWeather();
  }

  /// Memilih lokasi baru dari hasil pencarian atau daftar favorit
  Future<void> selectLocation(LocationModel location) async {
    _currentLocation = location;
    await _storageService.saveLastLocation(location);
    await _checkFavoriteStatus();
    await fetchWeather();
  }

  /// Mengambil data cuaca dari Open-Meteo REST API
  Future<void> fetchWeather() async {
    _state = WeatherViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _apiService.getWeatherForecast(
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude,
      );
      _state = WeatherViewState.loaded;
    } catch (e) {
      _state = WeatherViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  /// Memperbarui cuaca (misalnya melalui Swipe-to-refresh)
  Future<void> refresh() async {
    await _checkFavoriteStatus();
    try {
      _weatherData = await _apiService.getWeatherForecast(
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude,
      );
      _state = WeatherViewState.loaded;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  /// Memeriksa apakah lokasi saat ini tersimpan sebagai favorit di Local Storage
  Future<void> _checkFavoriteStatus() async {
    _isFavorite = await _storageService.isFavorite(_currentLocation);
    notifyListeners();
  }

  /// Menambahkan / menghapus lokasi saat ini dari daftar favorit
  Future<void> toggleFavorite() async {
    if (_isFavorite) {
      await _storageService.removeFavorite(_currentLocation);
      _isFavorite = false;
    } else {
      await _storageService.addFavorite(_currentLocation);
      _isFavorite = true;
    }
    notifyListeners();
  }
}
