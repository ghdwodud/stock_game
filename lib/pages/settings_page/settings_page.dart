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
    // 초기값은 현재 locale 기준
    final current = Get.locale?.languageCode;
    _selectedLanguage = current == 'en' ? 'English' : '한국어';
  }

  void _changeLanguage(String lang) {
    final locale = _languages[lang]!;
    setState(() {
      _selectedLanguage = lang;
    });
    Get.updateLocale(locale);
    Get.snackbar('언어 변경됨', '$lang 로 언어가 변경되었습니다.');
  }

  void _resetData() {
    Get.defaultDialog(
      title: '초기화',
      middleText: '모든 데이터를 초기화하시겠습니까?',
      textCancel: '취소',
      textConfirm: '확인',
      onConfirm: () {
        // TODO: 리셋 로직
        Get.back();
        Get.snackbar('초기화 완료', '데이터가 초기화되었습니다.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '언어 설정',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          const Divider(height: 32),
          ListTile(title: const Text('데이터 초기화'), onTap: _resetData),
          const Divider(),
          const ListTile(title: Text('앱 버전'), subtitle: Text('v0.1.0')),
        ],
      ),
    );
  }
}
