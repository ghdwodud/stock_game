import 'package:com.jyhong.stock_game/pages/chat/chat_room/chat_room_page.dart';
import 'package:com.jyhong.stock_game/pages/friend/friend_page.dart';
import 'package:com.jyhong.stock_game/pages/home/home_page.dart';
import 'package:com.jyhong.stock_game/pages/market/all_stocks/all_stocks_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockGameMainPage extends StatefulWidget {
  @override
  _StockGameMainPageState createState() => _StockGameMainPageState();
}

class _StockGameMainPageState extends State<StockGameMainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return AllStocksPage();
      case 2:
        return FriendsPage();
      case 3:
        return ChatRoomPage();
      default:
        return Center(child: Text('페이지를 찾을 수 없습니다.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex),
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
            icon: Icon(Icons.person_add),
            label: 'friend'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'chat'.tr,
          ),
        ],
      ),
    );
  }
}
