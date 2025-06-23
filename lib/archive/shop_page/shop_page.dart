import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:com.jyhong.stock_game/pages/home/home_controller.dart';
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
            Get.snackbar('reward_success'.tr, 'watch_ad_reward_success'.tr);
          } catch (e) {
            print('❌ 광고 보상 지급 실패: $e');
            Get.snackbar('error'.tr, 'watch_ad_reward_fail'.tr);
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
      Get.snackbar('ad_loading'.tr, 'please_try_again_later'.tr);
      _loadRewardedAd();
    }
  }

  void _claimDailyReward() {
    Get.snackbar('daily_reward'.tr, 'daily_reward_success'.tr);
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'shop'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _watchAdReward,
              icon: const Icon(Icons.ondemand_video, size: 28),
              label: Text(
                'watch_ad_reward'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 출석 보상 버튼은 일단 주석 처리된 상태
            // ElevatedButton.icon(
            //   onPressed: _claimDailyReward,
            //   icon: const Icon(Icons.calendar_today, size: 26),
            //   label: Text(
            //     'daily_reward'.tr,
            //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size.fromHeight(60),
            //     backgroundColor: Colors.lightBlue.shade300,
            //     foregroundColor: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
