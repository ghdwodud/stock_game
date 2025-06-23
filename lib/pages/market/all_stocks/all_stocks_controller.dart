import 'dart:async';
import 'package:com.jyhong.stock_game/models/stock_model.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:get/get.dart';

class AllStocksController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<StockModel> allStocks = <StockModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs; // 추가: 새로고침 상태

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchAllStocks();

    // ✅ 10초마다 갱신
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (_) {
      fetchAllStocks();
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void fetchAllStocks() async {
    if (isRefreshing.value) return; // 이미 새로고침 중이면 방지

    isRefreshing.value = true; // 새로고침 시작
    try {
      isLoading.value = true;
      final data = await _apiService.get('/stocks');

      // 데이터 갱신 시, 화면 깜빡임 방지
      final updatedStocks = List<StockModel>.from(
        data.map((e) => StockModel.fromJson(e)),
      );

      // 리스트 갱신
      allStocks.value = updatedStocks;
    } catch (e) {
      print('❌ fetchAllStocks error: $e');
      Get.snackbar('에러', '주식 데이터를 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false; // 새로고침 끝
    }
  }
}
