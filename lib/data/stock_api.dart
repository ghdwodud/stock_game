import '../services/api_service.dart';

class StockApi {
  final _api = ApiService();

  Future<List<dynamic>> fetchStocks() async {
    final res = await _api.get('/stocks');
    return res['data'];
  }

  Future<void> buyStock(String stockId, int amount) async {
    await _api.post('/stocks/buy', {
      'stockId': stockId,
      'amount': amount,
    });
  }
}
