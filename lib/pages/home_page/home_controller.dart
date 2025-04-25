import 'dart:async';

import 'package:com.jyhong.stock_game/models/user_profile_model.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthService _authService = Get.find<AuthService>();

  Rx<UserPortfolioModel?> userPortfolio = Rx<UserPortfolioModel?>(null);
  RxBool isLoading = false.obs;

  Timer? _refreshTimer; // 🔥 타이머 추가

  @override
  void onInit() {
    super.onInit();
    fetchPortfolio(); // 초기 로딩은 로딩 띄움

    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchPortfolio(showLoading: false); // 주기 갱신은 로딩 없이
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel(); // 🔥 컨트롤러 dispose 시 타이머 정리
    super.onClose();
  }

  void fetchPortfolio({bool showLoading = true}) async {
    if (showLoading) {
    isLoading.value = true;
    }

    try {
      final userId = _authService.userUuid;
      final data = await _apiService.get('/users/$userId/portfolio');

      userPortfolio.value = UserPortfolioModel.fromJson(data);
    } catch (e, st) {
      print('❌ 포트폴리오 불러오기 실패: $e\n$st');
      Get.snackbar(
        '에러',
        '포트폴리오 정보를 불러오지 못했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (showLoading) {
      isLoading.value = false;
    }
  }
}

}
