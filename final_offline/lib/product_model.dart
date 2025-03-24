class Product {
  final int productCode;
  final String productName;
  final double cost;
  final int amount;

  Product({
    required this.productCode,
    required this.productName,
    required this.cost,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productCode: json['product_code'],
      productName: json['product_name'],
      cost: json['cost'].toDouble(),
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode,
      'productName': productName,
      'cost': cost,
      'amount': amount,
    };
  }

}
