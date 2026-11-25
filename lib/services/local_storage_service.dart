import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class LocalStorageService {
  static const String _keyFavorites = 'weather_favorite_locations';
  static const String _keyHistory = 'weather_search_history';
  static const String _keyLastLocation = 'weather_last_location';

  /// Mendapatkan daftar lokasi favorit dari Local Storage
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyFavorites);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Menambahkan lokasi ke daftar favorit
  Future<bool> addFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    // Cek apakah sudah ada (berdasarkan id atau koordinat/nama)
    if (!favorites.any((item) => item == location)) {
      favorites.add(location);
      return _saveFavoriteList(favorites);
    }
    return true;
  }

  /// Menghapus lokasi dari daftar favorit
  Future<bool> removeFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item == location);
    return _saveFavoriteList(favorites);
  }

  /// Memeriksa apakah lokasi adalah favorit
  Future<bool> isFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item == location);
  }

  /// Helper untuk menyimpan list favorit
  Future<bool> _saveFavoriteList(List<LocationModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => e.toJson()).toList();
    return prefs.setString(_keyFavorites, jsonEncode(jsonList));
  }

  /// Mendapatkan riwayat pencarian
  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyHistory);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Menambahkan kota ke riwayat pencarian (maksimal 10 kota terakhir)
  Future<void> addSearchHistory(LocationModel location) async {
    final history = await getSearchHistory();
    history.removeWhere((item) => item == location);
    history.insert(0, location);
    if (history.length > 10) {
      history.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonList = history.map((e) => e.toJson()).toList();
    await prefs.setString(_keyHistory, jsonEncode(jsonList));
  }

  /// Menghapus semua riwayat pencarian
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }

  /// Menyimpan lokasi terakhir yang dipilih pengguna
  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, jsonEncode(location.toJson()));
  }

  /// Mendapatkan lokasi terakhir yang dipilih pengguna, atau default jika belum ada
  Future<LocationModel> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyLastLocation);
    if (jsonString == null || jsonString.isEmpty) {
      return LocationModel.defaultLocation;
    }

    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return LocationModel.fromJson(decoded);
    } catch (_) {
      return LocationModel.defaultLocation;
    }
  }
}
