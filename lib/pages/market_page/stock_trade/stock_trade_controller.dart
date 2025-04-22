import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/models/stock_model.dart';

class StockTradeController extends GetxController {
  late final StockModel stock;
  final ApiService _apiService = ApiService();

  final qtyController = TextEditingController();
  RxList<double> priceHistory = <double>[].obs;
  RxBool isLoading = false.obs;

  Timer? _historyTimer;

  @override
  void onInit() {
    super.onInit();
    stock = Get.arguments;
    fetchPriceHistory();

    // ✅ 10초마다 갱신 (원하면 60초로 설정 가능)
    _historyTimer = Timer.periodic(Duration(seconds: 10), (_) {
      fetchPriceHistory();
    });
  }

  void fetchPriceHistory() async {
    try {
      final data = await _apiService.get(
        '/stock-history/stock/${stock.id}/history',
      );
      priceHistory.value = List<double>.from(data.map((e) => e.toDouble()));
    } catch (e) {
      print('❌ 가격 히스토리 가져오기 실패: $e');
    }
  }

  void onBuy() {
    final qty = int.tryParse(qtyController.text);
    if (qty == null || qty <= 0) {
      Get.snackbar('오류', '유효한 수량을 입력하세요');
      return;
    }
    print('🔼 매수 ${stock.name} $qty주');
  }

  void onSell() {
    final qty = int.tryParse(qtyController.text);
    if (qty == null || qty <= 0) {
      Get.snackbar('오류', '유효한 수량을 입력하세요');
      return;
    }
    print('🔽 매도 ${stock.name} $qty주');
  }

  @override
  void onClose() {
    qtyController.dispose();
    _historyTimer?.cancel(); // ✅ 타이머 꼭 종료
    super.onClose();
  }
}
