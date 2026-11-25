import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

class SearchViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  SearchViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  List<LocationModel> _searchResults = [];
  List<LocationModel> get searchResults => _searchResults;

  List<LocationModel> _favorites = [];
  List<LocationModel> get favorites => _favorites;

  List<LocationModel> _history = [];
  List<LocationModel> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _query = '';
  String get query => _query;

  bool get isQueryEmpty => _query.trim().isEmpty;
  bool get hasResults => _searchResults.isNotEmpty;

  /// Memuat data favorit dan riwayat pencarian dari Local Storage
  Future<void> loadFavoritesAndHistory() async {
    _favorites = await _storageService.getFavorites();
    _history = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Melakukan pencarian lokasi ke Open-Meteo Geocoding REST API
  Future<void> search(String query) async {
    _query = query;
    _errorMessage = null;

    if (query.trim().isEmpty) {
      _searchResults = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchLocation(query);
      if (_searchResults.isEmpty) {
        _errorMessage = 'Tidak ditemukan lokasi dengan nama "$query".';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menghapus query pencarian
  void clearSearch() {
    _query = '';
    _searchResults = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Dipanggil ketika pengguna memilih suatu lokasi (menyimpan ke riwayat)
  Future<void> onLocationSelected(LocationModel location) async {
    await _storageService.addSearchHistory(location);
    _history = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Toggle status favorit suatu lokasi
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = _favorites.any((item) => item == location);
    if (isFav) {
      await _storageService.removeFavorite(location);
    } else {
      await _storageService.addFavorite(location);
    }
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  /// Memeriksa apakah lokasi berstatus favorit
  bool isLocationFavorite(LocationModel location) {
    return _favorites.any((item) => item == location);
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearHistory() async {
    await _storageService.clearSearchHistory();
    _history = [];
    notifyListeners();
  }
}
