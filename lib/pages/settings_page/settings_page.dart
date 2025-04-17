import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '설정 페이지',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
