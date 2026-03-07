import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/enums/app_enums.dart';
import 'package:wisecare_agent/models/home/agent_task_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'map_tab_variables.dart';
part 'widgets/map_header.dart';
part 'widgets/map_overlay_buttons.dart';
part 'widgets/map_bottom_sheet.dart';

/// Default map center (San Francisco area). Replace with user location when available.
const LatLng _kDefaultMapCenter = LatLng(37.7749, -122.4194);
const double _kDefaultZoom = 12.0;
const double _kMinZoom = 3.0;
const double _kMaxZoom = 18.0;

/// Tile URL and subdomains per layer. No API key required.
TileLayer _tileLayerFor(MapLayerType type) {
  const userAgent = 'wisecare_agent';
  switch (type) {
    case MapLayerType.standard:
      return TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: userAgent,
      );
    case MapLayerType.dark:
      return TileLayer(
        urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
        userAgentPackageName: userAgent,
      );
    case MapLayerType.light:
      return TileLayer(
        urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
        userAgentPackageName: userAgent,
      );
    case MapLayerType.voyager:
      return TileLayer(
        urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
        userAgentPackageName: userAgent,
      );
    case MapLayerType.terrain:
      return TileLayer(
        urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
        userAgentPackageName: userAgent,
      );
  }
}

/// Map tab: Agent View with header, OSM map (flutter_map), overlay buttons, and active requests bottom sheet.
class MapTabScreen extends StatefulWidget {
  const MapTabScreen({super.key});

  @override
  State<MapTabScreen> createState() => _MapTabScreenState();
}

class _MapTabScreenState extends State<MapTabScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  LatLng? _userLocation;
  MapLayerType _mapLayer = MapLayerType.standard;
  bool _mapControllerReady = false;
  LatLng? _pendingInitialCenter;
  bool _locationFetchFailed = false;
  bool _locationSnackbarShown = false;

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  void initState() {
    super.initState();
    _fetchAndSetInitialLocation();
  }

  Future<void> _fetchAndSetInitialLocation() async {
    try {
      final status = await Permission.location.request();
      if (!mounted) return;
      if (!status.isGranted) {
        _pendingInitialCenter = _kDefaultMapCenter;
        _locationFetchFailed = true;
        _refresh();
        _tryApplyInitialCamera();
        _showLocationFailedSnackbarIfNeeded();
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (!mounted) return;
      final userLatLng = LatLng(position.latitude, position.longitude);
      _userLocation = userLatLng;
      _pendingInitialCenter = userLatLng;
      _refresh();
      _tryApplyInitialCamera();
    } catch (_) {
      if (!mounted) return;
      _pendingInitialCenter = _kDefaultMapCenter;
      _locationFetchFailed = true;
      _refresh();
      _tryApplyInitialCamera();
      _showLocationFailedSnackbarIfNeeded();
    }
  }

  void _tryApplyInitialCamera() {
    if (_pendingInitialCenter == null || !_mapControllerReady) return;
    _mapController.move(_pendingInitialCenter!, _kDefaultZoom);
  }

  void _showLocationFailedSnackbarIfNeeded() {
    if (!_locationFetchFailed || _locationSnackbarShown) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _locationSnackbarShown) return;
      _locationSnackbarShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location cannot be fetched right now. Showing default map.',
            style: GoogleFonts.lexend(fontSize: 14, color: Skin.color(Co.onPrimary)),
          ),
          backgroundColor: Skin.color(Co.loginHeading),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  List<Marker> _buildMarkersWithUserLocation(BuildContext context) {
    final list = List<Marker>.from(_markers);
    if (_userLocation != null) {
      final photoUrl = context.watch<ProfileProvider>().profile?.profilePhotoUrl;
      list.add(
        Marker(
          point: _userLocation!,
          width: 40,
          height: 40,
          child: _UserLocationPin(photoUrl: photoUrl),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.mapAreaBg),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _MapHeader(),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _kDefaultMapCenter,
                        initialZoom: _kDefaultZoom,
                        minZoom: _kMinZoom,
                        maxZoom: _kMaxZoom,
                        onMapReady: () {
                          _mapControllerReady = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _tryApplyInitialCamera();
                          });
                        },
                      ),
                      children: [
                        _tileLayerFor(_mapLayer),
                        MarkerLayer(markers: _buildMarkersWithUserLocation(context)),
                      ],
                    ),
                  ),
                  _MapOverlayButtons(
                    mapController: _mapController,
                    selectedLayer: _mapLayer,
                    onUserLocationFound: (latLng) {
                      _userLocation = latLng;
                      _refresh();
                    },
                    onLayerSelected: (layer) {
                      _mapLayer = layer;
                      _refresh();
                    },
                  ),
                  const Positioned.fill(
                    child: _MapBottomSheet(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Blue pin for the current user/agent location on the map. Uses profile photo when available.
class _UserLocationPin extends StatelessWidget {
  const _UserLocationPin({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final blue = Skin.color(Co.mapMarkerPharmacy);
    final hasValidPhotoUrl = photoUrl != null && photoUrl!.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: hasValidPhotoUrl
            ? Image.network(
                photoUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _UserLocationPinPlaceholder(blue: blue),
              )
            : _UserLocationPinPlaceholder(blue: blue),
      ),
    );
  }
}

/// Placeholder inner content when no profile photo. Inlined as widget per NEW_SCREEN_DEV.
class _UserLocationPinPlaceholder extends StatelessWidget {
  const _UserLocationPinPlaceholder({required this.blue});

  final Color blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      color: blue,
      alignment: Alignment.center,
      child: const Icon(Icons.person_rounded, size: 22, color: Colors.white),
    );
  }
}
