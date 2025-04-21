class StockModel {
  final String symbol;
  final String name;
  final double price;
  final double changeRate;
  final int quantity;

  StockModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changeRate,
    required this.quantity,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] ?? '', // null이면 빈 문자열
      name: json['name'] ?? '', // null이면 빈 문자열
      price: (json['price'] ?? 0).toDouble(),
      changeRate: (json['changeRate'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}
