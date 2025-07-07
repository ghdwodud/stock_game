import 'package:com.jyhong.stock_game/pages/chat/chat_room/chat_room_page.dart';
import 'package:com.jyhong.stock_game/pages/friend/friend_page.dart';
import 'package:com.jyhong.stock_game/pages/home/home_page.dart';
import 'package:com.jyhong.stock_game/pages/market/all_stocks/all_stocks_page.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:com.jyhong.stock_game/services/chat_room_service.dart';
import 'package:com.jyhong.stock_game/services/chat_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockGameMainPage extends StatefulWidget {
  final int initialIndex;

  const StockGameMainPage({super.key, this.initialIndex = 0});

  @override
  _StockGameMainPageState createState() => _StockGameMainPageState();
}

class _StockGameMainPageState extends State<StockGameMainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _initializeChatRooms();
  }

  void _initializeChatRooms() async {
    try {
      final authService = Get.find<AuthService>();
      final myUuid = authService.userUuid;

      if (myUuid.isEmpty) {
        debugPrint('❌ UUID 없음 - 채팅방 초기화 생략');
        return;
      }

      final rooms = await Get.find<ChatRoomService>().fetchMyChatRooms(myUuid);
      final roomIds = rooms.map((r) => r['id'] as String).toList();

      Get.find<ChatSocketService>().joinMultipleRooms(roomIds);
      debugPrint('✅ ${roomIds.length}개 채팅방 join 완료');
    } catch (e) {
      debugPrint('❌ 채팅방 초기화 실패: $e');
    }
  }

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
        return const Center(child: Text('페이지를 찾을 수 없습니다.'));
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
