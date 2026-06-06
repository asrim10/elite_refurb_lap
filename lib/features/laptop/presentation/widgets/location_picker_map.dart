import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LocationPickerMap extends StatefulWidget {
  final BaatoCoordinate? selectedLocation;
  final ValueChanged<BaatoCoordinate> onTap;
  final VoidCallback onUseCurrentLocation;
  final TextEditingController addressController;

  const LocationPickerMap({
    super.key,
    required this.selectedLocation,
    required this.onTap,
    required this.onUseCurrentLocation,
    required this.addressController,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late final BaatoMapController _mapController;
  bool _mapReady = false;
  bool _styleLoaded = false;
  BaatoCoordinate? _currentUserLocation;

  @override
  void initState() {
    super.initState();
    _mapController = BaatoMapController();
  }

  void _onMapCreated(BaatoMapController controller) {
    _mapReady = true;
  }

  void _onStyleLoaded() {
    _styleLoaded = true;
    _updateMarker();
  }

  void _clearMarkers() {
    try {
      _mapController.markerManager.clearMarkers();
    } catch (_) {
      // clearMarkers may not be available in all versions
    }
  }

  void _updateMarker() {
    if (!_mapReady || !_styleLoaded || widget.selectedLocation == null) return;
    try {
      _clearMarkers();
      _mapController.markerManager.addMarker(
        BaatoSymbolOption(
          geometry: widget.selectedLocation!,
          textField: 'Selected',
          iconSize: 1.2,
        ),
      );
    } catch (_) {
      // Marker manager may not be initialized
    }
  }

  Future<void> _handleUseCurrentLocation() async {
    // If we already have a GPS fix, use it
    if (_currentUserLocation != null) {
      widget.onTap(_currentUserLocation!);
      _mapController.cameraManager.moveTo(
        _currentUserLocation!,
        zoom: 15,
      );
      return;
    }

    // Otherwise try the native map's myLocation tracking
    try {
      await _mapController.cameraManager.moveToMyLocation();
    } catch (_) {
      // Fallback to parent handler
      widget.onUseCurrentLocation();
    }
  }

  void _onUserLocationUpdated(UserLocation location) {
    _currentUserLocation = BaatoCoordinate(
      latitude: location.position.latitude,
      longitude: location.position.longitude,
    );
  }

  @override
  void didUpdateWidget(LocationPickerMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_mapReady || !_styleLoaded) return;
    if (widget.selectedLocation != oldWidget.selectedLocation &&
        widget.selectedLocation != null) {
      _mapController.cameraManager.moveTo(
        widget.selectedLocation!,
        zoom: 14,
      );
      _updateMarker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressField(),
        const SizedBox(height: 8),
        _buildMap(),
      ],
    );
  }

  Widget _buildAddressField() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: const Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: TextFormField(
        controller: widget.addressController,
        style: const TextStyle(
          color: Color(0xFF1A1C1C),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Enter address or tap on map',
          hintStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.my_location,
              color: Color(0xFF705A4E),
              size: 20,
            ),
            onPressed: _handleUseCurrentLocation,
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 250,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEEEEE),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          BaatoMap(
            controller: _mapController,
            initialPosition: BaatoCoordinate(
              latitude: 27.7172,
              longitude: 85.3240,
            ),
            initialZoom: 12.0,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.none,
            style: BaatoMapStyle.breeze,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            onUserLocationUpdated: _onUserLocationUpdated,
            onMapClick: (_, coordinate, __) {
              widget.onTap(coordinate);
            },
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                  () => PanGestureRecognizer()),
            },
          ),
          if (widget.selectedLocation != null)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Lat: ${widget.selectedLocation!.latitude.toStringAsFixed(4)}, '
                  'Lng: ${widget.selectedLocation!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
