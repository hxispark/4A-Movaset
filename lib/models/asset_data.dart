import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AssetData {
  final String id;
  final String name;
  final LatLng latLng;
  final String status;
  final int statusColorValue;
  final String sumberPeminjaman;
  final String penanggungjawab;
  final String geoFencingArea;
  final String imagePath;
  final DateTime? lastUpdated;

  const AssetData({
    required this.id,
    required this.name,
    required this.latLng,
    required this.status,
    required this.statusColorValue,
    required this.sumberPeminjaman,
    required this.penanggungjawab,
    required this.geoFencingArea,
    required this.imagePath,
    this.lastUpdated,
  });

  Color get statusColor => Color(statusColorValue);

  // ─── Parse dari JSON (API / Firestore / mock) ───────────────────────────────
  factory AssetData.fromJson(Map<String, dynamic> json) {
    return AssetData(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      latLng: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lon'] as num).toDouble(),
      ),
      status: json['status']?.toString() ?? 'Offline',
      statusColorValue: _statusToColor(json['status']?.toString() ?? 'Offline'),
      sumberPeminjaman: json['sumber_peminjaman']?.toString() ?? '-',
      penanggungjawab: json['penanggungjawab']?.toString() ?? '-',
      geoFencingArea: json['geo_fencing_area']?.toString() ?? '-',
      imagePath: json['image_path']?.toString() ?? '',
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'].toString())
          : null,
    );
  }

  // ─── Buat salinan dengan field tertentu diubah ───────────────────────────────
  AssetData copyWith({
    String? id,
    String? name,
    LatLng? latLng,
    String? status,
    int? statusColorValue,
    String? sumberPeminjaman,
    String? penanggungjawab,
    String? geoFencingArea,
    String? imagePath,
    DateTime? lastUpdated,
  }) {
    return AssetData(
      id: id ?? this.id,
      name: name ?? this.name,
      latLng: latLng ?? this.latLng,
      status: status ?? this.status,
      statusColorValue: statusColorValue ?? _statusToColor(status ?? this.status),
      sumberPeminjaman: sumberPeminjaman ?? this.sumberPeminjaman,
      penanggungjawab: penanggungjawab ?? this.penanggungjawab,
      geoFencingArea: geoFencingArea ?? this.geoFencingArea,
      imagePath: imagePath ?? this.imagePath,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // ─── Helper: status string → warna ──────────────────────────────────────────
  static int _statusToColor(String status) {
    switch (status) {
      case 'Aktif':
        return 0xFF1DBF8A;
      case 'Luar Zona':
        return 0xFFFF9A2E;
      default:
        return 0xFF9AA0B2; // Offline / unknown
    }
  }

  // ─── Label waktu update terakhir ────────────────────────────────────────────
  String get lastUpdatedLabel {
    if (lastUpdated == null) return 'Tidak diketahui';
    final diff = DateTime.now().difference(lastUpdated!);
    if (diff.inSeconds < 60) return '${diff.inSeconds} detik lalu';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}