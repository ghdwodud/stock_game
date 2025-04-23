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

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Rich Black
  colorScheme: ColorScheme.dark(
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF161616), // 조금 더 밝은 카드 배경
    primary: Color(0xFF5AC8FA), // 라이트 블루 포인트
    secondary: Color(0xFF64B5F6),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF101417),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white, // ← 100% 흰색으로
      fontWeight: FontWeight.w500, // ← 조금 굵게
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFE0E0E0), // ← 약간 소프트한 화이트 (95% 느낌)
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF5AC8FA),
      foregroundColor: Colors.black, // 버튼 텍스트 강조
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    ),
  ),

  cardTheme: const CardTheme(
    color: Color(0xFF161616), // ← 배경(0xFF0A0A0A)보다 확실히 밝음
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Game',
      debugShowCheckedModeBanner: false,
      // 라이트 모드 테마 설정 (사용자가 라이트 모드로 전환 시 적용)
      darkTheme: darkTheme,
      // 기본적으로 다크 모드 적용
      themeMode: ThemeMode.dark,

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
