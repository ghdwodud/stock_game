import 'package:com.jyhong.stock_game/models/stock_model.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:get/get.dart';

class AllStocksController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<StockModel> allStocks = <StockModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStocks();
  }

  void fetchAllStocks() async {
    isLoading.value = true;
    try {
      final data = await _apiService.get('/stocks');

      allStocks.value = List<StockModel>.from(
        data.map((e) => StockModel.fromJson(e)),
      );
    } catch (e) {
      print('❌ fetchAllStocks error: $e');
      Get.snackbar('에러', '주식 데이터를 불러오지 못했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}
