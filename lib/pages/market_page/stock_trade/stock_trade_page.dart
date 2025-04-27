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
      appBar: AppBar(title: Text('${stock.name} ${'trade'.tr}')), // ✅
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'current_price'.tr}: ₩ ${stock.price.toStringAsFixed(2)}', // ✅
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.priceHistory.isEmpty) {
                return Center(child: Text('no_chart_data'.tr)); // ✅
              }
              return _buildPriceChart(controller.priceHistory);
            }),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                '${'max_buy_quantity'.tr}: ${controller.maxBuyQuantityRx.value}${'shares'.tr}',
              ), // ✅
            ),
            Obx(
              () => Text(
                '${'holding_quantity'.tr}: ${controller.holdingQuantityRx.value}${'shares'.tr}',
              ), // ✅
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'enter_quantity'.tr, // ✅
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'increase_quantity'.tr, // ✅
                  onPressed: () {
                    final current =
                        int.tryParse(controller.qtyController.text) ?? 0;
                    controller.qtyController.text = (current + 1).toString();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  tooltip: 'decrease_quantity'.tr, // ✅
                  onPressed: () {
                    final current =
                        int.tryParse(controller.qtyController.text) ?? 1;
                    if (current > 1) {
                      controller.qtyController.text = (current - 1).toString();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_up),
                  tooltip: 'max_buy'.tr, // ✅
                  onPressed: () {
                    controller.qtyController.text =
                        controller.maxBuyQuantityRx.value.toString();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_double_arrow_down),
                  tooltip: 'max_sell'.tr, // ✅
                  onPressed: () {
                    controller.qtyController.text =
                        controller.holdingQuantityRx.value.toString();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.onBuy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('buy'.tr), // ✅
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.onSell,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('sell'.tr), // ✅
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
