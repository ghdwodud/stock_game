import 'package:com.jyhong.stock_game/models/holding_model.dart';

class UserPortfolioModel {
  final String nickname;
  final double cash;
  final double stockValue;
  final double totalAsset;
  final double profitRate;
  final List<HoldingModel> holdings; // ✅ 추가!

  UserPortfolioModel({
    required this.nickname,
    required this.cash,
    required this.stockValue,
    required this.totalAsset,
    required this.profitRate,
    required this.holdings,
  });

  factory UserPortfolioModel.fromJson(Map<String, dynamic> json) {
    return UserPortfolioModel(
      nickname: json['nickname'],
      cash: (json['cash'] as num).toDouble(),
      stockValue: (json['stockValue'] as num).toDouble(),
      totalAsset: (json['totalAsset'] as num).toDouble(),
      profitRate: (json['profitRate'] as num).toDouble(),
      holdings:
          (json['holdings'] as List<dynamic>? ?? [])
              .map((e) => HoldingModel.fromJson(e))
              .toList(),
    );
  }
}


