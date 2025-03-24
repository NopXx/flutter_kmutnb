// คลาส Product สำหรับเก็บข้อมูลสินค้า
class Product {
  // คุณสมบัติที่ใช้เก็บข้อมูลของสินค้า
  final int productCode;    // รหัสสินค้า ใช้เป็น primary key
  final String productName; // ชื่อสินค้า
  final double cost;        // ราคาสินค้า
  final int amount;         // จำนวนสินค้า

  // Constructor แบบ named parameters พร้อมกำหนดให้ทุกพารามิเตอร์เป็น required
  Product({
    required this.productCode,
    required this.productName,
    required this.cost,
    required this.amount,
  });

  // Factory constructor สำหรับแปลงข้อมูล JSON เป็นอ็อบเจ็กต์ Product
  // ใช้เมื่อรับข้อมูลจาก API และต้องการแปลงเป็นอ็อบเจ็กต์
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productCode: json['product_code'],  // รับค่า product_code จาก JSON
      productName: json['product_name'],  // รับค่า product_name จาก JSON
      cost: json['cost'].toDouble(),      // แปลงค่า cost เป็น double
      amount: json['amount'],             // รับค่า amount จาก JSON
    );
  }

  // เมธอดสำหรับแปลงอ็อบเจ็กต์ Product เป็น Map ในรูปแบบ JSON
  // ใช้เมื่อต้องการส่งข้อมูลไปยัง API
  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode, // ชื่อคีย์ต้องตรงกับที่ API คาดหวัง
      'productName': productName,
      'cost': cost,
      'amount': amount,
    };
  }
}