import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_stocks_controller.dart';
import '../stock_trade/stock_trade_page.dart';

class AllStocksPage extends StatelessWidget {
  final AllStocksController controller = Get.put(AllStocksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('전체 주식 목록')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.allStocks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('불러올 주식이 없습니다.'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchAllStocks,
                  child: Text('다시 시도'),
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
