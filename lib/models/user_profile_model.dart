class UserPortfolioModel {
  final String nickname;
  final int cash;
  final int stockValue;
  final int totalAsset;
  final double profitRate;

  UserPortfolioModel({
    required this.nickname,
    required this.cash,
    required this.stockValue,
    required this.totalAsset,
    required this.profitRate,
  });

  factory UserPortfolioModel.fromJson(Map<String, dynamic> json) {
    return UserPortfolioModel(
      nickname: json['nickname'],
      cash: json['cash'],
      stockValue: json['stockValue'],
      totalAsset: json['totalAsset'],
      profitRate: (json['profitRate'] as num).toDouble(),
    );
  }
}
