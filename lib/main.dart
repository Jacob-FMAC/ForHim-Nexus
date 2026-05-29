import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/admin_provider.dart';
import 'config/theme_config.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch all unhandled Flutter errors (prevents silent white screen on web)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  runApp(const ForHimPassApp());
}

class ForHimPassApp extends StatelessWidget {
  const ForHimPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => AdminProvider()..initialize()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'ForHim Pass',
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.darkTheme,
            locale: localeProvider.locale,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
