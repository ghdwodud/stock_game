import 'dart:async';
import 'dart:io';

import 'package:com.jyhong.stock_game/models/stock_model.dart';
import 'package:com.jyhong.stock_game/models/user_profile_model.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthService _authService = Get.find<AuthService>();

  Rx<UserPortfolioModel?> userPortfolio = Rx<UserPortfolioModel?>(null);
  RxBool isLoading = false.obs;
  RxString avatarUrl = ''.obs;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchPortfolio();
    avatarUrl.value = _authService.avatarUrl ?? '';

    print('onInit avatarUrl:${avatarUrl.value}');
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchPortfolio(showLoading: false);
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchPortfolio({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }

    try {
      final userId = _authService.userUuid;
      final data = await _apiService.get('/users/$userId/portfolio');
      userPortfolio.value = UserPortfolioModel.fromJson(data);
    } catch (e, st) {
      print('❌ 포트폴리오 불러오기 실패: $e\n$st');
      _showErrorSnackbar('포트폴리오 정보를 불러오지 못했습니다.');
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  Future<StockModel> getStockInfo(int stockId) async {
    final data = await _apiService.get('/stocks/$stockId');
    return StockModel.fromJson(data);
  }

  Future<void> pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      final uploadedUrl = await _apiService.uploadAvatar(file);

      avatarUrl.value = uploadedUrl;
      _authService.avatarUrl = uploadedUrl;

      Get.snackbar('완료', '프로필 이미지가 변경되었습니다.');
    } catch (e) {
      print('❌ 이미지 업로드 실패: $e');
      _showErrorSnackbar('이미지 업로드 중 오류 발생');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
