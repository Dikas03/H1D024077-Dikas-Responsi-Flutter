class LocationModel {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? timezone;

  const LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.timezone,
  });

  /// Factory untuk membuat LocationModel dari respons JSON Open-Meteo Geocoding API
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Lokasi Tidak Dikenal',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  /// Konversi LocationModel ke Map JSON untuk penyimpanan di Local Storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'timezone': timezone,
    };
  }

  /// String representasi nama lengkap wilayah, misalnya: "Jakarta, DKI Jakarta, Indonesia"
  String get fullAddress {
    final parts = <String>[];
    parts.add(name);
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  /// Lokasi default awal (Jakarta) jika belum ada riwayat atau favorit tersimpan
  static const LocationModel defaultLocation = LocationModel(
    id: 1642911,
    name: 'Jakarta',
    latitude: -6.21462,
    longitude: 106.84513,
    country: 'Indonesia',
    admin1: 'Jakarta',
    timezone: 'Asia/Jakarta',
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          ((id != null && id == other.id) ||
              (name == other.name &&
                  (latitude - other.latitude).abs() < 0.001 &&
                  (longitude - other.longitude).abs() < 0.001));

  @override
  int get hashCode => (id ?? name.hashCode) ^ latitude.hashCode ^ longitude.hashCode;
}
