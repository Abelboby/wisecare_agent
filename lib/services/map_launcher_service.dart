import 'package:url_launcher/url_launcher.dart';

/// Opens a location in an external map app (e.g. Google Maps in browser or installed app).
/// Does not draw the map inside the app; hands coordinates to the system.
class MapLauncherService {
  MapLauncherService._();

  /// Opens the given coordinates in Google Maps (external app or browser).
  /// Returns [true] if something opened, [false] otherwise.
  static Future<bool> openInGoogleMaps(double latitude, double longitude) async {
    try {
      final uri = Uri.parse(
        'https://www.google.com/maps?q=$latitude,$longitude',
      );
      return launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}
