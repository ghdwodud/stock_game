import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  void _watchAdReward() {
    // TODO: 광고 보고 보상 로직 추가
    Get.snackbar('보상 지급', '광고를 시청하고 10,000원이 지급되었습니다!');
  }

  void _claimDailyReward() {
    // TODO: 출석 보상 로직 추가
    Get.snackbar('출석 보상', '오늘의 출석 보상으로 5,000원이 지급되었습니다!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상점')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _watchAdReward,
              icon: const Icon(Icons.ondemand_video),
              label: const Text('광고 보고 보상 받기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _claimDailyReward,
              icon: const Icon(Icons.calendar_today),
              label: const Text('출석 보상 받기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
