class StockModel {
  final int id; // ✅ 추가
  final String symbol;
  final String name;
  final double price;
  final double changeRate;
  final int quantity;
  final List<double> history;

  StockModel({
    required this.id, // ✅ 추가
    required this.symbol,
    required this.name,
    required this.price,
    required this.changeRate,
    required this.quantity,
    required this.history,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] ?? 0, // ✅ 추가
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      changeRate: (json['changeRate'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}
