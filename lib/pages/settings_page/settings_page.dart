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
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'language'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedLanguage,
            isExpanded: true,
            items:
                _languages.keys.map((lang) {
                  return DropdownMenuItem(value: lang, child: Text(lang));
                }).toList(),
            onChanged: (val) {
              if (val != null) _changeLanguage(val);
            },
          ),
          const Divider(),

          // 데이터 초기화 기능은 잠깐 주석 처리해둔 상태
          // ListTile(
          //   title: Text('reset'.tr),
          //   onTap: _resetData,
          // ),
          ListTile(
            title: Text('app_version'.tr),
            subtitle: const Text('v0.1.0'),
          ),
        ],
      ),
    );
  }
}
