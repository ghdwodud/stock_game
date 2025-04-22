import 'package:com.jyhong.stock_game/models/stock_model.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockTradeController extends GetxController {
  late final StockModel stock;
  final ApiService _apiService = ApiService();

  final qtyController = TextEditingController();
  RxList<double> priceHistory = <double>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    stock = Get.arguments;
    fetchPriceHistory(); // 진입 시 가격 히스토리 가져오기
  }

  void fetchPriceHistory() async {
    isLoading.value = true;
    try {
      final data = await _apiService.get(
        '/stock-history/stock/${stock.id}/history',
      );
      priceHistory.value = List<double>.from(data.map((e) => e.toDouble()));
    } catch (e) {
      print('❌ 가격 히스토리 요청 실패: $e');
      Get.snackbar('에러', '차트 데이터를 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
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
    super.onClose();
  }
}
