class StockModel {
  final String symbol;
  final double price;
  final int quantity;

  StockModel({
    required this.symbol,
    required this.price,
    required this.quantity,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'],
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}
