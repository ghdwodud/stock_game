import 'package:com.jyhong.stock_game/pages/home_page/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final portfolio = controller.userPortfolio.value;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 유저 카드
            if (portfolio != null)
              _buildUserCard(portfolio.nickname)
            else
              _buildErrorCard('사용자 정보를 불러올 수 없습니다.'),

            const SizedBox(height: 16),

            // 자산 카드
            if (portfolio != null)
            _buildAssetCard(
              portfolio.totalAsset,
              portfolio.cash,
              portfolio.stockValue,
              portfolio.profitRate,
              )
            else
              _buildErrorCard(
                '포트폴리오 정보를 불러올 수 없습니다.',
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
                const Text('초보 투자자'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(double total, double cash, double stock, double rate) {
    // 새로운 수익률 계산
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
            const Text('총 자산', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              '₩ ${_formatNumber(total)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text('보유 현금: ₩ ${_formatNumber(cash)}'),
            Text('주식 평가금액: ₩ ${_formatNumber(stock)}'),
            const SizedBox(height: 4),
            Text(
              '수익률: $ratePrefix${((profitRate - 1) * 100).toStringAsFixed(2)}%',
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
        title: const Text('출석 보상 이벤트 진행 중!'),
        subtitle: const Text('매일 출석하고 현금 5,000원을 받아가세요!'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: 상점 페이지로 이동
          Get.snackbar('이벤트', '출석 보상은 상점에서 받을 수 있어요.');
        },
      ),
    );
  }

  Widget _buildMyStocksPreview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          const ListTile(
            title: Text('보유 종목 요약'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(height: 1),
          Obx(() {
            final holdings = controller.userPortfolio.value?.holdings ?? [];

            if (holdings.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('보유 종목이 없습니다.')),
              );
            }

            return Column(
              children:
                  holdings.map((holding) {
                    return FutureBuilder(
                      future: controller.getStockInfo(holding.stockId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const ListTile(title: Text('불러오는 중...'));
                        }

                        final stock = snapshot.data!;
                        final profitRate =
                            holding.avgBuyPrice > 0
                                ? (stock.price - holding.avgBuyPrice) /
                                    holding.avgBuyPrice
                                : 0.0;

                        return ListTile(
                          title: Text(stock.symbol),
                          subtitle: Text('${holding.quantity}주 보유'),
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
              ElevatedButton(onPressed: retry, child: const Text('다시 시도')),
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
