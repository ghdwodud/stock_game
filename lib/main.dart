
import 'package:com.jyhong.stock_game/pages/market_page/market_page.dart';
import 'package:com.jyhong.stock_game/pages/portfolio_page/portfolio_page.dart';
import 'package:com.jyhong.stock_game/pages/settings_page/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/stock_game_main_page.dart';

final logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/onboarding',
      getPages: [
        GetPage(name: '/onboarding', page: () => OnboardingPage()),
        GetPage(name: '/main', page: () => StockGameMainPage()),
        GetPage(name: '/market', page: () => MarketPage()),
        GetPage(name: '/portfolio', page: () => PortfolioPage()),
        GetPage(name: '/settings', page: () => SettingsPage()),
      ],
    );
  }
}
