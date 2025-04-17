import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int quantity = 0;

  List<FlSpot> sampleData = [
    FlSpot(0, 100),
    FlSpot(1, 110),
    FlSpot(2, 90),
    FlSpot(3, 120),
    FlSpot(4, 105),
    FlSpot(5, 130),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('삼성전자'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 📈 차트
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sampleData,
                      isCurved: true,
                      color: Colors.indigo,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // 💸 매수/매도 영역
            Row(
              children: [
                Text("수량: "),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: quantity.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        quantity = int.tryParse(val) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '수량 입력',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 매수 로직
                      print("매수: $quantity");
                    },
                    child: Text('매수'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 매도 로직
                      print("매도: $quantity");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('매도'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
