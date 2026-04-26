import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../models/asset_data.dart';

class AssetProvider extends ChangeNotifier {
  List<AssetData> _assets = [];
  bool isLoading = false;
  String? errorMessage;

  // ─── Getter data ─────────────────────────────────────────────────────────────
  List<AssetData> get assets => _assets;
  int get totalAssets  => _assets.length;
  int get activeCount  => _assets.where((a) => a.status == 'Aktif').length;
  int get outsideCount => _assets.where((a) => a.status == 'Luar Zona').length;
  int get offlineCount => _assets.where((a) => a.status == 'Offline').length;

  // ─── Load data ───────────────────────────────────────────────────────────────
  // Sekarang pakai mock — nanti tinggal ganti isi blok try dengan http.get
  // atau Firestore.instance.collection('assets').get()
  Future<void> loadAssets() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // ── TODO: ganti dengan pemanggilan API / Firestore ──────────────────────
      // Contoh HTTP:
      //   final res = await http.get(Uri.parse('https://api.kalian.com/assets'));
      //   final List data = jsonDecode(res.body);
      //   _assets = data.map((e) => AssetData.fromJson(e)).toList();
      //
      // Contoh Firestore:
      //   final snap = await FirebaseFirestore.instance.collection('assets').get();
      //   _assets = snap.docs.map((d) => AssetData.fromJson({...d.data(), 'id': d.id})).toList();
      // ────────────────────────────────────────────────────────────────────────

      // MOCK DATA — hapus saat backend sudah siap
      await Future.delayed(const Duration(milliseconds: 800));
      _assets = _mockAssets();

    } catch (e) {
      errorMessage = 'Gagal memuat data aset: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  // ─── Update posisi satu aset (dipanggil dari MQTT/LoRa listener) ─────────────
  void updateAssetPosition({
    required String assetId,
    required double lat,
    required double lon,
    String? status,
  }) {
    final idx = _assets.indexWhere((a) => a.id == assetId);
    if (idx == -1) return;

    _assets[idx] = _assets[idx].copyWith(
      latLng: LatLng(lat, lon),
      status: status,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  // ─── Mock data (sementara tidak ada backend) ─────────────────────────────────
  List<AssetData> _mockAssets() {
    return [
      AssetData.fromJson({
        'id': '01',
        'name': 'Tripod Camera',
        'lat': 1.1192,
        'lon': 104.0488,
        'status': 'Aktif',
        'sumber_peminjaman': 'RTF',
        'penanggungjawab': 'Mega',
        'geo_fencing_area': 'Gedung Utama',
        'image_path':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Leica_Geosystems_TPS1200.jpg/320px-Leica_Geosystems_TPS1200.jpg',
        'last_updated': DateTime.now()
            .subtract(const Duration(minutes: 2))
            .toIso8601String(),
      }),
      AssetData.fromJson({
        'id': '02',
        'name': 'Drones',
        'lat': 1.1155,
        'lon': 104.0510,
        'status': 'Luar Zona',
        'sumber_peminjaman': 'Logistik',
        'penanggungjawab': 'Muna',
        'geo_fencing_area': 'Area Parkir',
        'image_path':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/280px-PNG_transparency_demonstration_1.png',
        'last_updated': DateTime.now()
            .subtract(const Duration(minutes: 15))
            .toIso8601String(),
      }),
    ];
  }
}