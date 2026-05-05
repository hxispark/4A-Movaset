import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssetData {
  final String id;           // uuid dari Firestore / doc.id
  final String name;
  final LatLng latLng;       // dari collection locations (nanti realtime)
  final String status;       // "dipinjam" | "tidak"
  final String sumberPeminjaman;
  final String penanggungjawab;
  final String geoFencingArea;
  final String imagePath;    // foto pertama (images[0]) atau fallback
  final List<String> images; // semua URL foto dari Storage
  final String description;
  final String category;

  const AssetData({
    required this.id,
    required this.name,
    required this.latLng,
    required this.status,
    required this.sumberPeminjaman,
    required this.penanggungjawab,
    required this.geoFencingArea,
    required this.imagePath,
    this.images = const [],
    this.description = '',
    this.category = '',
  });

  // Warna status otomatis dari value string
  Color get statusColor {
    switch (status) {
      case 'dipinjam':   return const Color(0xFFFF9A2E);
      case 'tidak':      return const Color(0xFF1DBF8A);
      default:           return const Color(0xFF9AA0B2);
    }
  }

  // Masih ada biar widget lama tidak error
  int get statusColorValue => statusColor.value;

  // Dari Firestore doc — latLng diisi default dulu,
  // nanti di-update dari collection locations
  factory AssetData.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final imgs = List<String>.from(d['images'] ?? []);
    return AssetData(
      id:                doc.id,
      name:              d['name']               ?? '',
      description:       d['description']        ?? '',
      category:          d['category']           ?? '',
      status:            d['status']             ?? 'tidak',
      sumberPeminjaman:  d['sumber_peminjaman']  ?? '',
      penanggungjawab:   d['penanggung_jawab']   ?? '',
      geoFencingArea:    d['geo_fencing_area']   ?? '',
      imagePath:         imgs.isNotEmpty ? imgs.first : '',
      images:            imgs,
      latLng:            const LatLng(1.1186, 104.0485), // default, update dari locations
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name':               name,
    'description':        description,
    'category':           category,
    'status':             status,
    'sumber_peminjaman':  sumberPeminjaman,
    'penanggung_jawab':   penanggungjawab,
    'geo_fencing_area':   geoFencingArea,
    'images':             images,
    'created_at':         FieldValue.serverTimestamp(),
    'updated_at':         FieldValue.serverTimestamp(),
    'deleted_at':         null,
  };

  AssetData copyWith({
    String?      status,
    LatLng?      latLng,
    List<String>? images,
  }) => AssetData(
    id:               id,
    name:             name,
    description:      description,
    category:         category,
    status:           status ?? this.status,
    sumberPeminjaman: sumberPeminjaman,
    penanggungjawab:  penanggungjawab,
    geoFencingArea:   geoFencingArea,
    imagePath:        images != null && images.isNotEmpty
                          ? images.first
                          : imagePath,
    images:           images ?? this.images,
    latLng:           latLng ?? this.latLng,
  );
}

// Fallback hardcoded — dipakai selama Firestore belum ada data
// Hapus ini nanti kalau sudah full Firestore
final List<AssetData> appAssets = [
  AssetData(
    id: '01',
    name: 'Tripod Camera',
    latLng: const LatLng(1.1192, 104.0488),
    status: 'tidak',
    sumberPeminjaman: 'RTF',
    penanggungjawab: 'Mega',
    geoFencingArea: 'Gedung Utama',
    imagePath:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Leica_Geosystems_TPS1200.jpg/320px-Leica_Geosystems_TPS1200.jpg',
  ),
  AssetData(
    id: '02',
    name: 'Drones',
    latLng: const LatLng(1.1155, 104.0510),
    status: 'dipinjam',
    sumberPeminjaman: 'Logistik',
    penanggungjawab: 'Budi',
    geoFencingArea: 'Area Parkir',
    imagePath:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/280px-PNG_transparency_demonstration_1.png',
  ),
];