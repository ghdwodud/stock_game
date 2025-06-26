import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_stocks_controller.dart';
import '../stock_trade/stock_trade_page.dart';

class AllStocksPage extends StatelessWidget {
  final AllStocksController controller = Get.put(AllStocksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'all_stocks'.tr), // ✅ tr 적용

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
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ), // ✅ 일치시킴
          itemCount: controller.allStocks.length,
          itemBuilder: (context, index) {
            final stock = controller.allStocks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12), // ✅ 아래 여백만
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: Text(
                    stock.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '₩ ${stock.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${stock.changeRate >= 0 ? '+' : ''}${stock.changeRate.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              stock.changeRate >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.swap_horiz,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => StockTradePage(), arguments: stock);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
