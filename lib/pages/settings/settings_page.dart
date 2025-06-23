import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _languages = {
    '한국어': const Locale('ko', 'KR'),
    'English': const Locale('en', 'US'),
  };

  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final current = Get.locale?.languageCode;
    _selectedLanguage = current == 'en' ? 'English' : '한국어';
  }

  void _changeLanguage(String lang) {
    final locale = _languages[lang]!;
    setState(() {
      _selectedLanguage = lang;
    });
    Get.updateLocale(locale);
    Get.snackbar(
      'language_changed'.tr,
      '${lang} ${'language_changed_success'.tr}',
    );
  }

  void _resetData() {
    Get.defaultDialog(
      title: 'reset'.tr,
      middleText: 'reset_confirm'.tr,
      textCancel: 'cancel'.tr,
      textConfirm: 'ok'.tr,
      onConfirm: () {
        // TODO: 리셋 로직
        Get.back();
        Get.snackbar('reset_complete'.tr, 'reset_success'.tr);
      },
    );
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'settings'.tr),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'language'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(fontSize: 16, color: Colors.black),
                items:
                    _languages.keys.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(
                          lang,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) _changeLanguage(val);
                },
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 16),

          ListTile(
            title: Text(
              'app_version'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'v0.1.0',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          // 데이터 초기화 기능 필요 시 여기에 다시 추가 가능
          // const SizedBox(height: 24),
          // ListTile(
          //   title: Text('reset'.tr, style: TextStyle(fontSize: 16)),
          //   onTap: _resetData,
          // ),
        ],
      ),
    );
  }

}
