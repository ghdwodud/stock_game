import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/dashboard/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return GetMaterialApp(
  title: 'Stock Game',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    primarySwatch: Colors.indigo, // AppBar 등 색상
    scaffoldBackgroundColor: Colors.white, // 배경 흰색
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    ),
  ),
  home: DashboardPage(),
);
  }
}
