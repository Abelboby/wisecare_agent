import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class WiseCareAgentApp extends StatelessWidget {
  const WiseCareAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderRegister.getProviders(),
      child: ValueListenableBuilder<AppThemeMode>(
        valueListenable: Skin.themeMode,
        builder: (_, mode, __) {
          return MaterialApp.router(
            key: Key(mode.name),
            title: 'WiseCare Agent',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.commonThemeData,
            scrollBehavior: AppTheme.appScrollBehavior,
            routerConfig: AppNavigator.router,
          );
        },
      ),
    );
  }
}
