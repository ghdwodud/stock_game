import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  // 채팅방 목록 더미 데이터
  final chatRooms =
      <Map<String, dynamic>>[
        {'uuid': 'user123', 'nickname': '홍길동', 'lastMessage': '잘 지내?'},
        {'uuid': 'user456', 'nickname': '김영희', 'lastMessage': '오랜만이야!'},
        {'uuid': 'user789', 'nickname': '이철수', 'lastMessage': 'ㅋㅋㅋㅋ'},
      ].obs;

  // 추후: API 또는 소켓으로 받아올 수도 있음
}
