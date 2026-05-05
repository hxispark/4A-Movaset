import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/asset_data.dart';
import 'asset_marker.dart';

final List<LatLng> geoFencePoints = [
  const LatLng(1.118829, 104.046915),
  const LatLng(1.119756, 104.048258),
  const LatLng(1.120489, 104.049755),
  const LatLng(1.119549, 104.050144),
  const LatLng(1.117758, 104.049415),
  const LatLng(1.117636, 104.047094),
];

class MapLayerStack extends StatelessWidget {
  final MapController? controller;
  final List<AssetData> assets;
  final int selectedIndex;
  final MapOptions? options;

  const MapLayerStack({
    super.key,
    required this.assets,
    this.controller,
    this.selectedIndex = -1,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: options ??
          const MapOptions(
            initialCenter: LatLng(1.1186, 104.0485),
            initialZoom: 17,
          ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.movaset.app',
        ),
        PolygonLayer(
          polygons: [
            Polygon(
              points: geoFencePoints,
              color: const Color.fromARGB(201, 58, 72, 6),
              borderColor: const Color.fromARGB(255, 14, 163, 0),
              borderStrokeWidth: 2.5,
            ),
          ],
        ),
        MarkerLayer(
          markers: List.generate(assets.length, (i) {
            final a = assets[i];
            final sel = selectedIndex == i;
            return Marker(
              point: a.latLng,
              width: sel ? 58 : 50,
              height: sel ? 58 : 50,
              child: AssetMarker(name: a.name, status: a.status, isSelected: sel),
            );
          }),
        ),
      ],
    );
  }
}