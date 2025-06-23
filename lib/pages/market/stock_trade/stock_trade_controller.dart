import 'dart:async';
import 'package:com.jyhong.stock_game/pages/home/home_controller.dart';
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
  RxInt holdingQuantityRx = 0.obs;
  RxInt maxBuyQuantityRx = 0.obs;
  Timer? _historyTimer;
  RxBool isSnackbarActive = false.obs;
  @override
  void onInit() {
    super.onInit();
    stock = Get.arguments;
    fetchPriceHistory();
    refreshHoldingInfo();

    // ✅ 5초마다 갱신
    _historyTimer = Timer.periodic(Duration(seconds: 5), (_) {
      fetchPriceHistory();
    });
  }

  @override
  void onClose() {
    qtyController.dispose();
    _historyTimer?.cancel(); // ✅ 타이머 꼭 종료
    super.onClose();
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

  void onBuy() async {
    final qty = int.tryParse(qtyController.text);
    if (qty == null || qty <= 0) {
      _showError('유효한 수량을 입력하세요');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.post('/transactions/buy', {
        'stockId': stock.id,
        'quantity': qty,
      });

      await Get.find<HomeController>().fetchPortfolio(showLoading: false);
      await refreshHoldingInfo();

      //_showSuccess('${stock.name} $qty주를 매수했습니다');

      print('🟢 매수 응답: $response');
    } catch (e) {
      print('❌ 매수 실패: $e');
      _showError('매수 실패: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void onSell() async {
    final qty = int.tryParse(qtyController.text);
    if (qty == null || qty <= 0) {
      _showError('유효한 수량을 입력하세요');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.post('/transactions/sell', {
        'stockId': stock.id,
        'quantity': qty,
      });

      await Get.find<HomeController>().fetchPortfolio(showLoading: false);
      await refreshHoldingInfo();

      //_showSuccess('${stock.name} $qty주를 매도했습니다');

      print('🟢 매도 응답: $response');
    } catch (e) {
      print('❌ 매도 실패: $e');
      _showError('매도 실패: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ 성공 시 스낵바
  void _showSuccess(String message, {Color color = Colors.black}) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
    );
  }

  /// ✅ 에러 시 스낵바
  void _showError(String message) {
    if (isSnackbarActive.value) return; // ✅ 이미 스낵바 뜨면 무시

    isSnackbarActive.value = true; // ✅ 스낵바 뜨기 전 true로 세팅

    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
    );

    // ✅ 스낵바 duration만큼 기다렸다가 false로 리셋
    Future.delayed(const Duration(seconds: 2), () {
      isSnackbarActive.value = false;
    });
  }

  Future<void> refreshHoldingInfo() async {
    final holdings =
        Get.find<HomeController>().userPortfolio.value?.holdings ?? [];
    final holding = holdings.firstWhereOrNull((h) => h.stockId == stock.id);

    holdingQuantityRx.value = holding?.quantity ?? 0;

    final cash = Get.find<HomeController>().userPortfolio.value?.cash ?? 0;
    maxBuyQuantityRx.value =
        (cash / stock.price).floor(); // ✅ 매수 가능 수량도 같이 업데이트
  }
}
