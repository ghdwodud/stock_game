import 'package:com.jyhong.stock_game/pages/friend/friend_page.dart';
import 'package:com.jyhong.stock_game/pages/home/home_page.dart';
import 'package:com.jyhong.stock_game/pages/market/all_stocks/all_stocks_page.dart';
import 'package:com.jyhong.stock_game/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockGameMainPage extends StatefulWidget {
  @override
  _StockGameMainPageState createState() => _StockGameMainPageState();
}

class _StockGameMainPageState extends State<StockGameMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(), // 홈
    AllStocksPage(), // 시장
    FriendsPage(), // 상점
    ChatPage(), // 채팅
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
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        iconSize: 28,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'market'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add), // 친구 추가 아이콘
            label: 'friend'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), // ✅ 채팅 아이콘
            label: 'chat'.tr, // ✅ 번역 키 변경
          ),
        ],
      ),
    );
  }
}
