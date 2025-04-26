import 'package:com.jyhong.stock_game/pages/home_page/home_controller.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // ✅ 광고 패키지 추가

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ✅ 테스트용 광고 ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd 로딩 실패: $error');
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    );
  }

  void _watchAdReward() async {
    if (_isAdLoaded && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) async {
          try {
            await ApiService().post('/rewards/watch-ad', {}); // ✅ 서버에 보상 요청
            await Get.find<HomeController>().fetchPortfolio(
              showLoading: false,
            ); // ✅ 내 자산 새로고침
          Get.snackbar('보상 지급', '광고를 시청하고 10,000원이 지급되었습니다!');
          } catch (e) {
            print('❌ 광고 보상 지급 실패: $e');
            Get.snackbar('오류', '보상 지급에 실패했습니다.');
          }
        },
      );

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadRewardedAd();
        },
      );

      _rewardedAd = null;
      _isAdLoaded = false;
    } else {
      Get.snackbar('광고 준비 중', '잠시 후 다시 시도해주세요.');
      _loadRewardedAd();
    }
  }
  
  void _claimDailyReward() {
    Get.snackbar('출석 보상', '오늘의 출석 보상으로 5,000원이 지급되었습니다!');
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
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
