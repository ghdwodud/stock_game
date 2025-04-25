class HoldingModel {
  final int stockId;
  final int quantity;
  final double avgBuyPrice; // ✅ 추가!

  HoldingModel({
    required this.stockId,
    required this.quantity,
    required this.avgBuyPrice, // ✅ 생성자에 추가
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      stockId: json['stockId'],
      quantity: json['quantity'],
      avgBuyPrice: (json['avgBuyPrice'] ?? 0.0).toDouble(), // ✅ avgBuyPrice 추가
    );
  }
}