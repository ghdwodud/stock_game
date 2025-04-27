import 'package:com.jyhong.stock_game/pages/home_page/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home'.tr), centerTitle: true), // ✅ Home tr 처리
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final portfolio = controller.userPortfolio.value;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (portfolio != null)
              _buildUserCard(portfolio.nickname)
            else
              _buildErrorCard('user_info_load_fail'.tr),

            const SizedBox(height: 16),

            if (portfolio != null)
              _buildAssetCard(
                portfolio.totalAsset,
                portfolio.cash,
                portfolio.stockValue,
                portfolio.profitRate,
              )
            else
              _buildErrorCard(
                'portfolio_info_load_fail'.tr,
                retry: controller.fetchPortfolio,
              ),

            const SizedBox(height: 16),
            //_buildEventBanner(),
            const SizedBox(height: 16),
            _buildMyStocksPreview(),
          ],
        );
      }),
    );
  }

  Widget _buildUserCard(String nickname) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nickname, style: const TextStyle(fontSize: 16)),
                Text('beginner_investor'.tr), // ✅ '초보 투자자'
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(double total, double cash, double stock, double rate) {
    final profitRate = (total + cash) / (stock + cash);
    final rateColor = profitRate >= 1 ? Colors.green : Colors.red;
    final ratePrefix = profitRate >= 1 ? '+' : '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('total_assets'.tr, style: const TextStyle(fontSize: 16)), // ✅
            const SizedBox(height: 8),
            Text(
              '₩ ${_formatNumber(total)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text('${'cash'.tr}: ₩ ${_formatNumber(cash)}'), // ✅
            Text('${'stock_value'.tr}: ₩ ${_formatNumber(stock)}'), // ✅
            const SizedBox(height: 4),
            Text(
              '${'profit_rate'.tr}: $ratePrefix${((profitRate - 1) * 100).toStringAsFixed(2)}%',
              style: TextStyle(color: rateColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventBanner() {
    return Card(
      color: Colors.orange.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.campaign),
        title: Text('attendance_event'.tr), // ✅
        subtitle: Text('attendance_event_detail'.tr), // ✅
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Get.snackbar('event'.tr, 'check_in_shop'.tr); // ✅
        },
      ),
    );
  }

  Widget _buildMyStocksPreview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text('my_stocks_summary'.tr), // ✅
          ),
          const Divider(height: 1),
          Obx(() {
            final holdings = controller.userPortfolio.value?.holdings ?? [];

            if (holdings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text('no_stocks'.tr)), // ✅
              );
            }

            return Column(
              children:
                  holdings.map((holding) {
                    return FutureBuilder(
                      future: controller.getStockInfo(holding.stockId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListTile(title: Text('loading'.tr)); // ✅
                        }

                        final stock = snapshot.data!;
                        final profitRate =
                            holding.avgBuyPrice > 0
                                ? (stock.price - holding.avgBuyPrice) /
                                    holding.avgBuyPrice
                                : 0.0;

                        return ListTile(
                          title: Text(stock.symbol),
                          subtitle: Text(
                            '${holding.quantity}${'shares'.tr}',
                          ), // ✅
                          trailing: Text(
                            '${profitRate >= 0 ? '+' : ''}${(profitRate * 100).toStringAsFixed(2)}%',
                            style: TextStyle(
                              color:
                                  profitRate >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message, {VoidCallback? retry}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(message),
            if (retry != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(onPressed: retry, child: Text('retry'.tr)), // ✅
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(num value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }
}
