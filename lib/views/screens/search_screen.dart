import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../widgets/location_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadFavoritesAndHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    // Debounce 500ms agar tidak membebani API setiap ketikan huruf
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<SearchViewModel>().search(query);
      }
    });
  }

  void _selectLocation(LocationModel location) {
    final searchVM = context.read<SearchViewModel>();
    searchVM.onLocationSelected(location);
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<SearchViewModel>(
      builder: (context, searchVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cari & Pilih Lokasi'),
          ),
          body: Column(
            children: [
              // Kolom Pencarian Kota
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  onSubmitted: (value) => searchVM.search(value),
                  decoration: InputDecoration(
                    hintText: 'Ketik nama kota (misal: Bandung, Tokyo)...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              searchVM.clearSearch();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E2230) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Konten Utama: Hasil Pencarian vs Daftar Favorit & Riwayat
              Expanded(
                child: _buildContent(searchVM),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(SearchViewModel searchVM) {
    // 1. Kondisi Loading saat mencari
    if (searchVM.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(
              'Mencari lokasi...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 2. Jika ada query pencarian
    if (!searchVM.isQueryEmpty) {
      if (searchVM.errorMessage != null && searchVM.searchResults.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  searchVM.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: searchVM.searchResults.length,
        itemBuilder: (context, index) {
          final location = searchVM.searchResults[index];
          final isFav = searchVM.isLocationFavorite(location);

          return LocationTile(
            location: location,
            isFavorite: isFav,
            onTap: () => _selectLocation(location),
            onToggleFavorite: () => searchVM.toggleFavorite(location),
          );
        },
      );
    }

    // 3. Jika kolom pencarian kosong: Tampilkan Lokasi Favorit dan Riwayat Pencarian
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: const Icon(Icons.favorite_rounded),
                text: 'Favorit (${searchVM.favorites.length})',
              ),
              Tab(
                icon: const Icon(Icons.history_rounded),
                text: 'Riwayat (${searchVM.history.length})',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Tab 1: Daftar Favorit
                _buildFavoritesTab(searchVM),
                // Tab 2: Riwayat Pencarian
                _buildHistoryTab(searchVM),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab(SearchViewModel searchVM) {
    if (searchVM.favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border_rounded, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'Belum Ada Lokasi Favorit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Cari nama kota lalu simpan sebagai favorit dengan menekan tombol hati.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: searchVM.favorites.length,
      itemBuilder: (context, index) {
        final location = searchVM.favorites[index];
        return LocationTile(
          location: location,
          isFavorite: true,
          onTap: () => _selectLocation(location),
          onToggleFavorite: () => searchVM.toggleFavorite(location),
        );
      },
    );
  }

  Widget _buildHistoryTab(SearchViewModel searchVM) {
    if (searchVM.history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_rounded, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'Belum Ada Riwayat Pencarian',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Lokasi yang Anda pilih sebelumnya akan muncul di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Terakhir',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
              ),
              TextButton(
                onPressed: () => searchVM.clearHistory(),
                child: const Text('Hapus Semua', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: searchVM.history.length,
            itemBuilder: (context, index) {
              final location = searchVM.history[index];
              final isFav = searchVM.isLocationFavorite(location);
              return LocationTile(
                location: location,
                isFavorite: isFav,
                onTap: () => _selectLocation(location),
                onToggleFavorite: () => searchVM.toggleFavorite(location),
              );
            },
          ),
        ),
      ],
    );
  }
}
