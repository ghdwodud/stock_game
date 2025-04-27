import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static final locale = Get.deviceLocale ?? const Locale('en', 'US');
  static final fallbackLocale = const Locale('en', 'US');

  static Map<String, Map<String, String>> translations = {};

  static Future<void> loadTranslations() async {
    final enJson = await rootBundle.loadString('assets/lang/en_us.json');
    final koJson = await rootBundle.loadString('assets/lang/ko_kr.json');

    // ✅ 키를 'en_US', 'ko_KR'로 해야 한다 (대문자)
    translations['en_US'] = Map<String, String>.from(json.decode(enJson));
    translations['ko_KR'] = Map<String, String>.from(json.decode(koJson));
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
