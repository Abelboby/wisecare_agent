part of '../map_tab_screen.dart';

/// Map overlay buttons (location, layers) at top right. Matches Figma styling.
class _MapOverlayButtons extends StatelessWidget {
  const _MapOverlayButtons({
    required this.mapController,
    required this.selectedLayer,
    this.onUserLocationFound,
    this.onLayerSelected,
  });

  final MapController mapController;
  final MapLayerType selectedLayer;
  final void Function(LatLng)? onUserLocationFound;
  final void Function(MapLayerType)? onLayerSelected;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: _MapTabDimens.mapOverlayRight,
      top: _MapTabDimens.mapOverlayTop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MapOverlayButton(
            icon: Icons.my_location_rounded,
            onTap: () => _onMyLocationTap(context),
          ),
          const SizedBox(height: _MapTabDimens.mapOverlayGap),
          _MapOverlayButton(
            icon: Icons.layers_rounded,
            onTap: () => _onLayersTap(context),
          ),
        ],
      ),
    );
  }

  Future<void> _onMyLocationTap(BuildContext context) async {
    try {
      final status = await Permission.location.request();
      if (!context.mounted) return;
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is needed to go to your position.'),
          ),
        );
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!context.mounted) return;
      final userLatLng = LatLng(position.latitude, position.longitude);
      onUserLocationFound?.call(userLatLng);
      mapController.move(userLatLng, _kDefaultZoom);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not get location. ${e is Exception ? e.toString().replaceFirst('Exception: ', '') : e}',
          ),
        ),
      );
    }
  }

  void _onLayersTap(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Skin.color(Co.cardSurface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_MapTabDimens.sheetBorderRadius)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _MapTabDimens.sheetPaddingH,
            _MapTabDimens.sheetDragHandlePaddingV,
            _MapTabDimens.sheetPaddingH,
            _MapTabDimens.sheetPaddingBottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: _MapTabDimens.sheetDragHandleWidth,
                  height: _MapTabDimens.sheetDragHandleHeight,
                  decoration: BoxDecoration(
                    color: Skin.color(Co.mapSheetDragHandle),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Map style',
                style: GoogleFonts.lexend(
                  fontSize: _MapTabDimens.sheetTitleFontSize,
                  fontWeight: FontWeight.w700,
                  height: _MapTabDimens.sheetTitleHeight / _MapTabDimens.sheetTitleFontSize,
                  color: Skin.color(Co.mapAgentViewTitle),
                ),
              ),
              const SizedBox(height: 12),
              ...MapLayerType.values.map((layer) {
                final isSelected = selectedLayer == layer;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      onLayerSelected?.call(layer);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(
                            _iconForLayer(layer),
                            size: 22,
                            color: Skin.color(Co.mapAgentViewTitle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _labelForLayer(layer),
                              style: GoogleFonts.lexend(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Skin.color(Co.mapAgentViewTitle),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              size: 22,
                              color: Skin.color(Co.primary),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForLayer(MapLayerType layer) {
    switch (layer) {
      case MapLayerType.standard:
        return Icons.map_rounded;
      case MapLayerType.dark:
        return Icons.dark_mode_rounded;
      case MapLayerType.light:
        return Icons.light_mode_rounded;
      case MapLayerType.voyager:
        return Icons.explore_rounded;
      case MapLayerType.terrain:
        return Icons.terrain_rounded;
    }
  }

  String _labelForLayer(MapLayerType layer) {
    switch (layer) {
      case MapLayerType.standard:
        return 'Standard';
      case MapLayerType.dark:
        return 'Dark';
      case MapLayerType.light:
        return 'Light';
      case MapLayerType.voyager:
        return 'Voyager';
      case MapLayerType.terrain:
        return 'Terrain';
    }
  }
}

class _MapOverlayButton extends StatelessWidget {
  const _MapOverlayButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_MapTabDimens.mapOverlayButtonRadius),
        child: Container(
          width: _MapTabDimens.mapOverlayButtonSize,
          height: _MapTabDimens.mapOverlayButtonSize,
          decoration: BoxDecoration(
            color: Skin.color(Co.mapOverlayButtonBg),
            borderRadius: BorderRadius.circular(_MapTabDimens.mapOverlayButtonRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Icon(
            icon,
            size: _MapTabDimens.mapOverlayIconSize,
            color: Skin.color(Co.mapAgentViewTitle),
          ),
        ),
      ),
    );
  }
}
