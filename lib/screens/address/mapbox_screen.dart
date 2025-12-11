import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxScreen extends StatefulWidget {
  const MapboxScreen({super.key});

  @override
  State<MapboxScreen> createState() => _MapboxScreenState();
}

class _MapboxScreenState extends State<MapboxScreen> {
  MapboxMap? _mapboxMap;
  String _selectedAddress = 'Di chuyển bản đồ để chọn...';

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    // Initial geocode after map is created and camera is settled.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _updateAddressFromMapCenter();
    });
  }

  // This listener is called when the map becomes idle after any camera movement.
  void _onMapIdleListener(MapIdleEventData data) {
    _updateAddressFromMapCenter();
  }

  Future<void> _updateAddressFromMapCenter() async {
    if (_mapboxMap == null) return;

    try {
      final centerState = await _mapboxMap?.getCameraState();
      if (centerState == null) return;

      final centerPoint = centerState.center;
      final lon = centerPoint.coordinates.lng;
      final lat = centerPoint.coordinates.lat;

      // For simplicity, just return the coordinates as a string.
      // Reverse geocoding would require an external API call (e.g., via http package).
      if (mounted) {
        setState(() {
          _selectedAddress = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lon.toStringAsFixed(4)}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedAddress = 'Lỗi lấy tọa độ';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Địa Chỉ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedAddress),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MapWidget(
            onMapCreated: _onMapCreated,
            // Correctly assign the listener here.
            onMapIdleListener: _onMapIdleListener, 
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(105.804817, 21.028511)),
              zoom: 14.0,
            ),
            styleUri: MapboxStyles.MAPBOX_STREETS,
          ),
          // Center marker icon that does not move with the map
          const IgnorePointer(
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 50,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withAlpha(230), // Use withAlpha for opacity
              child: Text(
                _selectedAddress,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
