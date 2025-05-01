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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('${stock.name} ${'trade'.tr}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag, // ✅ 키보드 자연스럽게 닫히게
          children: [
            _buildPriceInfo(stock),
            const SizedBox(height: 16),
            _buildHoldingsInfo(),
            const SizedBox(height: 8),
            _buildQuantityInput(),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'current_price'.tr}: ₩ ${stock.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.priceHistory.isEmpty) {
            return Center(child: Text('no_chart_data'.tr));
          }
          return _buildPriceChart(controller.priceHistory);
        }),
      ],
    );
  }

Widget _buildHoldingsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            '${'max_buy_quantity'.tr}: ${controller.maxBuyQuantityRx.value}${'shares'.tr}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            '${'holding_quantity'.tr}: ${controller.holdingQuantityRx.value}${'shares'.tr}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }


  Widget _buildQuantityInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.qtyController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'enter_quantity'.tr,
              labelStyle: const TextStyle(fontSize: 14),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add, size: 24),
          tooltip: 'increase_quantity'.tr,
          onPressed: () {
            final current = int.tryParse(controller.qtyController.text) ?? 0;
            controller.qtyController.text = (current + 1).toString();
          },
        ),
        IconButton(
          icon: const Icon(Icons.remove, size: 24),
          tooltip: 'decrease_quantity'.tr,
          onPressed: () {
            final current = int.tryParse(controller.qtyController.text) ?? 1;
            if (current > 1) {
              controller.qtyController.text = (current - 1).toString();
            }
          },
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                controller.qtyController.text =
                    controller.maxBuyQuantityRx.value.toString();
              },
            ),
            const Text('최대매수', style: TextStyle(fontSize: 12)),
          ],
        ),
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.sell),
              onPressed: () {
                controller.qtyController.text =
                    controller.holdingQuantityRx.value.toString();
              },
            ),
            const Text('최대매도', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }


  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('buy'.tr),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.onSell,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('sell'.tr),
            ),
          ),
        ),
      ],
    );
  }
}
