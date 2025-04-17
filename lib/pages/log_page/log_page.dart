import 'package:flutter/material.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('거래 기록'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '로그 페이지',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
