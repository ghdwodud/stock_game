import 'package:com.jyhong.stock_game/pages/home_page/home_page.dart';
import 'package:com.jyhong.stock_game/pages/market_page/all_stocks/all_stocks_page.dart';
import 'package:com.jyhong.stock_game/pages/shop_page/shop_page.dart';
import 'package:com.jyhong.stock_game/pages/settings_page/settings_page.dart';
import 'package:flutter/material.dart';

class StockGameMainPage extends StatefulWidget {
  @override
  _StockGameMainPageState createState() => _StockGameMainPageState();
}

class _StockGameMainPageState extends State<StockGameMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(), // 홈
    AllStocksPage(), // 시장
    ShopPage(), // 상점
    SettingsPage(), // 설정
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: '시장'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: '상점'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
