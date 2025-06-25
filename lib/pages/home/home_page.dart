import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:com.jyhong.stock_game/pages/home/home_controller.dart';
import 'package:com.jyhong.stock_game/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'home'.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final portfolio = controller.userPortfolio.value;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            if (portfolio != null)
              _buildUserCard(portfolio.nickname)
            else
              _buildErrorCard('user_info_load_fail'.tr),

            const SizedBox(height: 24),

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

            const SizedBox(height: 24),
            //_buildEventBanner(),
            const SizedBox(height: 24),
            _buildMyStocksPreview(),
          ],
        );
      }),
    );
  }

  Widget _buildUserCard(String nickname) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            GestureDetector(
              onTap: controller.pickAndUploadImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(
                    () => UserAvatar(
                      avatarUrl: controller.avatarUrl.value,
                      radius: 30,
                      onTap: controller.pickAndUploadImage,
                      showEditIcon: true,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'beginner_investor'.tr,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(double total, double cash, double stock, double rate) {
    final initialAsset = 10000;
    final profitRate = total / initialAsset;
    final rateColor = profitRate >= 1 ? Colors.green : Colors.red;
    final ratePrefix = profitRate >= 1 ? '+' : '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'total_assets'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '₩ ${_formatNumber(total)}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${'cash'.tr}: ₩ ${_formatNumber(cash)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              '${'stock_value'.tr}: ₩ ${_formatNumber(stock)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '${'profit_rate'.tr}: $ratePrefix${((profitRate - 1) * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 14, color: rateColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyStocksPreview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(title: Text('my_stocks_summary'.tr)),
          const Divider(height: 1),
          Obx(() {
            final holdings = controller.userPortfolio.value?.holdings ?? [];

            if (holdings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text('no_stocks'.tr)),
              );
            }

            return Column(
              children:
                  holdings.map((holding) {
                    return FutureBuilder(
                      future: controller.getStockInfo(holding.stockId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListTile(title: Text('loading'.tr));
                        }

                        final stock = snapshot.data!;
                        final profitRate =
                            holding.avgBuyPrice > 0
                                ? (stock.price - holding.avgBuyPrice) /
                                    holding.avgBuyPrice
                                : 0.0;

                        return ListTile(
                          title: Text(
                            stock.symbol,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${holding.quantity}${'shares'.tr}'),
                              const SizedBox(height: 4),
                              Text(
                                '${'current_price'.tr}: ₩${_formatNumber(stock.price)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${'buy_price'.tr}: ₩${_formatNumber(holding.avgBuyPrice)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '${profitRate >= 0 ? '+' : ''}${(profitRate * 100).toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(message, style: const TextStyle(fontSize: 14)),
            if (retry != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: retry, child: Text('retry'.tr)),
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    return number
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (Match match) => '${match.group(1)},',
        );
  }
}
