import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/stock_model.dart';

class DashboardController extends GetxController {
  var cash = 1000000.0.obs; // 보유 현금
  var myStocks = <StockModel>[].obs;
  var allStocks = <StockModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

 void fetchDashboardData() async {
  final userId = 'test-user-1234'; // SharedPreferences에서 UUID 가져와도 OK
  final url = Uri.parse('http://10.0.2.2:3000/dashboard?userId=$userId'); // Android 에뮬레이터 기준
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    cash.value = data['cash'].toDouble();

    myStocks.value = List<StockModel>.from(
      data['myStocks'].map((e) => StockModel.fromJson(e)),
    );

    allStocks.value = List<StockModel>.from(
      data['allStocks'].map((e) => StockModel.fromJson(e)),
    );
  } else {
    print('서버 오류: ${response.statusCode}');
  }
}
}
