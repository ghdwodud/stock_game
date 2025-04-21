import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 나중에 실제 데이터로 대체
    final nickname = '게스트123';
    final cash = 1000000;
    final stockValue = 2250000;
    final totalAsset = cash + stockValue;
    final profitRate = 0.085; // +8.5%

    return Scaffold(
      appBar: AppBar(
        title: const Text('대시보드'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserCard(nickname),
          const SizedBox(height: 16),
          _buildAssetCard(totalAsset, cash, stockValue, profitRate),
          const SizedBox(height: 16),
          _buildEventBanner(),
          const SizedBox(height: 16),
          _buildMyStocksPreview(),
        ],
      ),
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

  Widget _buildAssetCard(int total, int cash, int stock, double rate) {
    final rateColor = rate >= 0 ? Colors.green : Colors.red;
    final ratePrefix = rate >= 0 ? '+' : '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('총 자산', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('₩ ${_formatNumber(total)}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('보유 현금: ₩ ${_formatNumber(cash)}'),
            Text('주식 평가금액: ₩ ${_formatNumber(stock)}'),
            const SizedBox(height: 4),
            Text('수익률: $ratePrefix${(rate * 100).toStringAsFixed(2)}%',
                style: TextStyle(color: rateColor)),
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
          ListTile(
            title: const Text('AAPL'),
            subtitle: const Text('5주 보유'),
            trailing: Text('+3.2%', style: TextStyle(color: Colors.green)),
          ),
          ListTile(
            title: const Text('TSLA'),
            subtitle: const Text('2주 보유'),
            trailing: Text('-1.1%', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int num) {
    return num.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }
}
