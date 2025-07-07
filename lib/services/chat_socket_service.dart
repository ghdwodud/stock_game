import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:com.jyhong.stock_game/main.dart';
import 'package:com.jyhong.stock_game/pages/chat/chat_room/chat_room_controller.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:com.jyhong.stock_game/services/chat_room_service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  late IO.Socket socket;
  bool _isConnected = false; // ✅ 중복 연결 방지

  /// 소켓 연결 시도
  void connect(String myUuid) {
    if (_isConnected) {
      logger.w('⚠️ [Socket] 이미 연결되어 있음 → 연결 생략 (userId: $myUuid)');
      return;
    }

    logger.i('🟡 [Socket] 연결 시도 중... userId: $myUuid');

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': myUuid}) // 서버에 userId 전달
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      logger.i('✅ [Socket] 연결됨');
    });

    socket.onConnectError((err) {
      logger.e('❌ [Socket] 연결 오류: $err');
    });

    socket.onError((err) {
      logger.e('❌ [Socket] 에러 발생: $err');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      logger.w('⚠️ [Socket] 연결 종료됨');
    });
  }

  /// 연결 해제
  void disconnect() {
    if (!_isConnected) {
      logger.w('🟤 [Socket] 연결 안되어 있음 → disconnect 생략');
      return;
    }

    logger.w('🔌 [Socket] 소켓 연결 종료 요청');
    _isConnected = false;
    socket.dispose();
  }

  /// 메시지 전송
  void sendMessage(Map<String, dynamic> message) {
    if (!_isConnected) {
      logger.w('❌ [Socket] 연결 안됨 → 메시지 전송 취소');
      return;
    }
    logger.i('📤 [Socket] 메시지 전송: $message');
    socket.emit('send_message', message);
  }

  /// 메시지 수신 핸들러 등록
  void onReceiveMessage(void Function(dynamic) handler) {
    logger.i('📡 [Socket] receive_message 리스너 등록');
    socket.off('receive_message');
    socket.on('receive_message', (data) {
      logger.i('📥 [Socket] 메시지 수신됨: $data');
      handler(data);
    });
  }

  /// 방 참가
  void joinRoom(String roomId) {
    logger.i('📥 [Socket] 방 참가 요청: $roomId');
    socket.emit('join', {'roomId': roomId});
  }

  /// 여러 방에 참가
  void joinMultipleRooms(List<String> roomIds) {
    for (final id in roomIds) {
      joinRoom(id);
    }
  }

  /// 서버로부터 새로운 방 알림 수신 → 자동 join
  void listenNewRooms() {
    socket.on('new_room', (data) async {
      final roomId = data['roomId'];
      joinRoom(roomId);
      logger.i('🆕 새로운 채팅방 참여됨: $roomId');

      // ✅ 채팅방 목록 재요청
      try {
        final auth = Get.find<AuthService>();
        final myUuid = auth.userUuid;
        final rooms = await Get.find<ChatRoomService>().fetchMyChatRooms(
          myUuid,
        );
        Get.find<ChatRoomController>().updateRooms(rooms);
      } catch (e) {
        logger.e('❌ 채팅방 목록 갱신 실패: $e');
      }
    });
  }

  /// 내가 만든 방을 상대방에게 알림
  void emitNewRoom(String targetUuid, String roomId) {
    logger.i('📡 [Socket] 새로운 방 알림 emit → $targetUuid / $roomId');
    socket.emit('notify_new_room', {
      'targetUuid': targetUuid,
      'roomId': roomId,
    });
  }

  /// 삭제된 채팅방 알림 수신 → 목록 갱신
  void listenDeletedRooms() {
    socket.on('room_deleted', (data) async {
      final roomId = data['roomId'];
      logger.i('🗑️ 삭제된 채팅방 알림 수신: $roomId');

      try {
        final auth = Get.find<AuthService>();
        final myUuid = auth.userUuid;
        final rooms = await Get.find<ChatRoomService>().fetchMyChatRooms(
          myUuid,
        );
        Get.find<ChatRoomController>().updateRooms(rooms);
      } catch (e) {
        logger.e('❌ 채팅방 삭제 후 목록 갱신 실패: $e');
      }
    });
  }

  /// 내가 삭제한 방을 상대방에게 알림
  void emitDeletedRoom(String targetUuid, String roomId) {
    logger.i('📡 [Socket] 방 삭제 알림 emit → $targetUuid / $roomId');
    socket.emit('notify_delete_room', {
      'targetUuid': targetUuid,
      'roomId': roomId,
    });
  }
}
