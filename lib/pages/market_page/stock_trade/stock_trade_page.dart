import 'package:com.jyhong.stock_game/models/stock_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'stock_trade_controller.dart';

class StockTradePage extends StatelessWidget {
  final controller = Get.put(StockTradeController());

  Widget _buildPriceChart(List<double> history) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots:
                  history
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList(),
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stock = controller.stock;

    return Scaffold(
      appBar: AppBar(title: Text('${stock.name} 거래')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재가: ₩ ${stock.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.priceHistory.isEmpty) {
                return const Center(child: Text('차트 데이터 없음'));
              }

              return _buildPriceChart(controller.priceHistory);
            }),
            const SizedBox(height: 16),
            TextField(
              controller: controller.qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '수량 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.onBuy,
                    child: const Text('매수'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.onSell,
                    child: const Text('매도'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
