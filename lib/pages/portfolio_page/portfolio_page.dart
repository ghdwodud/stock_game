import 'package:flutter/material.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 포트폴리오'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '보유 종목 페이지',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
