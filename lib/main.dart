import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_frame/device_frame.dart';

import 'package:wisecare_agent/enums/app_enums.dart';
import 'package:wisecare_agent/navigation/app_navigator.dart';
import 'package:wisecare_agent/provider/provider_register.dart';
import 'package:wisecare_agent/utils/theme/app_theme.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
  } catch (_) {}
  await Skin.retrieveTheme();
  runApp(const WiseCareAgentApp());
}

/// iOS-style home indicator bar overlaid at the bottom of the DeviceFrame screen.
/// Placed on top of app content so it stays visible regardless of Scaffold background.
class _IosHomeIndicator extends StatelessWidget {
  const _IosHomeIndicator();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

class WiseCareAgentApp extends StatelessWidget {
  const WiseCareAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderRegister.getProviders(),
      child: ValueListenableBuilder<AppThemeMode>(
        valueListenable: Skin.themeMode,
        builder: (_, mode, __) {
          final app = MaterialApp.router(
            key: Key(mode.name),
            title: 'WiseAgent',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.commonThemeData,
            scrollBehavior: AppTheme.appScrollBehavior,
            routerConfig: AppNavigator.router,
          );
          return kIsWeb
              ? Directionality(
                  textDirection: TextDirection.ltr,
                  child: DeviceFrame(
                    device: Devices.ios.iPhone15Pro,
                    screen: Stack(
                      children: [
                        app,
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 12,
                          child: _IosHomeIndicator(),
                        ),
                      ],
                    ),
                    orientation: Orientation.portrait,
                    isFrameVisible: true,
                  ),
                )
              : app;
        },
      ),
    );
  }
}
