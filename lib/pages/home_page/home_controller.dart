import 'package:com.jyhong.stock_game/models/user_profile_model.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthService _authService = Get.find<AuthService>();

  Rx<UserPortfolioModel?> userPortfolio = Rx<UserPortfolioModel?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPortfolio();
  }

  void fetchPortfolio() async {
    isLoading.value = true;
    try {
      final userId = _authService.currentUserId;
      final data = await _apiService.get('/users/$userId/portfolio');
      userPortfolio.value = UserPortfolioModel.fromJson(data);
    } catch (e) {
      Get.snackbar('에러', '포트폴리오 정보를 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}
