import 'package:com.jyhong.stock_game/pages/dashboard/dashboard_page.dart';
import 'package:com.jyhong.stock_game/pages/log_page/log_page.dart';
import 'package:com.jyhong.stock_game/pages/market_page/market_page.dart';
import 'package:com.jyhong.stock_game/pages/portfolio_page/portfolio_page.dart';
import 'package:com.jyhong.stock_game/pages/settings_page/settings_page.dart';
import 'package:flutter/material.dart';


class StockGameMainPage extends StatefulWidget {
  @override
  _StockGameMainPageState createState() => _StockGameMainPageState();
}

class _StockGameMainPageState extends State<StockGameMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),       // 홈
    MarketPage(),          // 주식시장
    PortfolioPage(),       // 내 보유 종목
    LogPage(),             // 거래 로그
    SettingsPage(),        // 설정
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
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: '포트폴리오'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
