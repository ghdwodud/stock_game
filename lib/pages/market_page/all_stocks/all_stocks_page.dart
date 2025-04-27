import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_stocks_controller.dart';
import '../stock_trade/stock_trade_page.dart';

class AllStocksPage extends StatelessWidget {
  final AllStocksController controller = Get.put(AllStocksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('all_stocks'.tr),
        centerTitle: true,
      ), // ✅ tr 적용

      body: Obx(() {
        if (controller.isLoading.value && !controller.isRefreshing.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allStocks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('no_stocks_to_load'.tr), // ✅
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchAllStocks,
                  child: Text('retry'.tr), // ✅
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.allStocks.length,
          itemBuilder: (context, index) {
            final stock = controller.allStocks[index];
            return ListTile(
              title: Text(stock.name),
              subtitle: Text('₩ ${stock.price.toStringAsFixed(2)}'),
              trailing: Text(
                '${stock.changeRate >= 0 ? '+' : ''}${stock.changeRate.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: stock.changeRate >= 0 ? Colors.green : Colors.red,
                ),
              ),
              onTap: () {
                Get.to(() => StockTradePage(), arguments: stock);
              },
            );
          },
        );
      }),
    );
  }
}
