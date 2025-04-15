import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대시보드'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '보유 현금: ₩${controller.cash.value.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('내 주식', style: TextStyle(fontSize: 16)),
              ...controller.myStocks.map(
                (stock) => ListTile(
                  title: Text('${stock.symbol} - ${stock.quantity}주'),
                  subtitle: Text('가격: ₩${stock.price}'),
                ),
              ),
              Divider(),
              Text('거래 가능한 종목', style: TextStyle(fontSize: 16)),
              ...controller.allStocks.map(
                (stock) => ListTile(
                  title: Text(stock.symbol),
                  subtitle: Text('가격: ₩${stock.price}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // 매수 화면 연결 예정
                    },
                    child: Text('매수'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
