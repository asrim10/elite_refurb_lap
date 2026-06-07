import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationPickerMap extends StatefulWidget {
  final BaatoCoordinate? selectedLocation;
  final ValueChanged<BaatoCoordinate> onTap;
  final VoidCallback onUseCurrentLocation;
  final TextEditingController addressController;
  final bool autoDetect;

  const LocationPickerMap({
    super.key,
    required this.selectedLocation,
    required this.onTap,
    required this.onUseCurrentLocation,
    required this.addressController,
    this.autoDetect = false,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late final BaatoMapController _mapController;
  bool _mapReady = false;
  bool _styleLoaded = false;
  BaatoCoordinate? _currentUserLocation;
  bool _pendingAutoDetect = false;
  bool _autoDetectAttempted = false;

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
    _tryAutoDetect();
  }

  void _tryAutoDetect() {
    if (!widget.autoDetect ||
        widget.selectedLocation != null ||
        _autoDetectAttempted) {
      return;
    }
    _autoDetectAttempted = true;
    _triggerAutoDetect();
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



  Future<void> _triggerAutoDetect() async {
    // If we already have a GPS fix, use it immediately
    if (_currentUserLocation != null) {
      _applyLocation(_currentUserLocation!);
      return;
    }

    // Set a timeout fallback in case GPS takes too long
    Future.delayed(const Duration(seconds: 10), () {
      if (!_pendingAutoDetect) {
        return;
      }
      _pendingAutoDetect = false;
      widget.onUseCurrentLocation();
    });

    _pendingAutoDetect = true;
    try {
      await _mapController.cameraManager.moveToMyLocation();
    } catch (_) {
      if (_pendingAutoDetect) {
        _pendingAutoDetect = false;
        widget.onUseCurrentLocation();
      }
    }
  }

  void _applyLocation(BaatoCoordinate coord) {
    widget.onTap(coord);
    _updateMarker();
    _mapController.cameraManager.moveTo(coord, zoom: 15);
  }

  Future<void> _handleSearchAddress() async {
    final query = widget.addressController.text.trim();
    if (query.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address to search')),
      );
      return;
    }

    HapticFeedback.lightImpact();

    try {
      // Step 1: Search for the place
      final searchResponse = await Baato.api.place.search(
        query,
        limit: 1,
      );

      if (!mounted) return;

      if (searchResponse.data == null || searchResponse.data!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results found for this address')),
        );
        return;
      }

      final searchPlace = searchResponse.data!.first;

      // Step 2: Get full place details (which include centroid coordinates)
      final detailResponse = await Baato.api.place.getDetail(searchPlace.placeId);

      if (!mounted) return;

      if (detailResponse.data == null || detailResponse.data!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get location details')),
        );
        return;
      }

      final place = detailResponse.data!.first;
      final coord = BaatoCoordinate(
        latitude: place.centroid.latitude,
        longitude: place.centroid.longitude,
      );

      // Update the address text with the place name
      widget.addressController.text = place.name;
      _applyLocation(coord);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  Future<void> _handleUseCurrentLocation() async {
    if (_currentUserLocation != null) {
      _applyLocation(_currentUserLocation!);
      return;
    }
    try {
      await _mapController.cameraManager.moveToMyLocation();
    } catch (_) {
      widget.onUseCurrentLocation();
    }
  }

  void _onUserLocationUpdated(UserLocation location) {
    final coord = BaatoCoordinate(
      latitude: location.position.latitude,
      longitude: location.position.longitude,
    );
    _currentUserLocation = coord;
    if (_pendingAutoDetect) {
      _pendingAutoDetect = false;
      _applyLocation(coord);
    }
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
    // Re-trigger auto-detect if location was cleared (e.g. navigating back and forth)
    if (widget.autoDetect &&
        widget.selectedLocation == null &&
        oldWidget.selectedLocation != null) {
      _autoDetectAttempted = false;
      _tryAutoDetect();
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
          hintText: 'Search a place or tap on map',
          hintStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFF705A4E),
                  size: 20,
                ),
                onPressed: _handleSearchAddress,
              ),
              IconButton(
                icon: const Icon(
                  Icons.my_location,
                  color: Color(0xFF705A4E),
                  size: 20,
                ),
                onPressed: _handleUseCurrentLocation,
              ),
            ],
          ),
        ),
        onFieldSubmitted: (_) => _handleSearchAddress(),
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
