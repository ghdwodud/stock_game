import 'package:com.jyhong.stock_game/models/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StockTradePage extends StatelessWidget {
  final StockModel stock = Get.arguments;
  final TextEditingController qtyController = TextEditingController();

  void _onBuy() {
    final qty = int.tryParse(qtyController.text);
    if (qty == null || qty <= 0) {
      Get.snackbar('오류', '유효한 수량을 입력하세요');
      return;
    }

    // TODO: 매수 API 호출
    print('🔼 매수 ${stock.name} $qty주');
  }

  void _onSell() {
    final qty = int.tryParse(qtyController.text);
    if (qty == null || qty <= 0) {
      Get.snackbar('오류', '유효한 수량을 입력하세요');
      return;
    }

    // TODO: 매도 API 호출
    print('🔽 매도 ${stock.name} $qty주');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${stock.name} 거래')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재가: ₩ ${stock.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '수량 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onBuy,
                    child: Text('매수'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSell,
                    child: Text('매도'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
