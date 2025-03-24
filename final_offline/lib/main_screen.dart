// นำเข้าแพคเกจที่จำเป็น
import 'dart:developer'; // สำหรับการดีบัคและบันทึกล็อก
import 'package:final_offline/notify.dart'; // คลาสการแจ้งเตือนที่กำหนดเอง
import 'package:final_offline/product_model.dart'; // คลาสโมเดลสินค้า
import 'package:flutter/material.dart'; // คอมโพเนนต์การออกแบบ Material ของ Flutter
import 'package:flutter/services.dart'; // บริการแพลตฟอร์มสำหรับข้อผิดพลาดการยืนยันตัวตนทางชีวมิติ
import 'package:http/http.dart' as http; // ไคลเอนต์ HTTP สำหรับคำขอ API
import 'dart:convert'; // การเข้ารหัส/ถอดรหัส JSON

import 'package:local_auth/local_auth.dart'; // ไลบรารีการยืนยันตัวตนทางชีวมิติ

// วิดเจ็ตหน้าจอหลัก - มีสถานะเพื่อจัดการข้อมูลสินค้า
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // รายการเก็บสินค้าทั้งหมด
  List<Product> products = [];

  // เริ่มต้นตัวช่วยการแจ้งเตือน
  Notify notify = Notify();

  // ตัวแปรการยืนยันตัวตนทางชีวมิติ
  late final LocalAuthentication auth;
  late bool
      _supportState; // ติดตามว่าอุปกรณ์รองรับการยืนยันตัวตนทางชีวมิติหรือไม่

  // ตัวควบคุมข้อความสำหรับช่องป้อนข้อมูลแบบฟอร์ม
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _amountController = TextEditingController();

  // URL ฐานสำหรับจุดปลายทาง API (10.0.2.2 คือเทียบเท่า localhost สำหรับจำลอง Android)
  final baseUrl = 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    // ดึงสินค้าเมื่อวิดเจ็ตเริ่มต้น
    fetchProducts();

    // เริ่มต้นการยืนยันตัวตนทางชีวมิติ
    auth = LocalAuthentication();
    // ตรวจสอบว่าอุปกรณ์รองรับการยืนยันตัวตนทางชีวมิติหรือไม่
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _supportState = isSupported;
      });
    });
  }

  // ฟังก์ชันเพื่อยืนยันตัวตนผู้ใช้โดยใช้ชีวมิติ
  Future<bool> _authenticate() async {
    try {
      // ขอการยืนยันตัวตนทางชีวมิติ
      bool authenticate = await auth.authenticate(
        localizedReason: 'Authentication required', // ข้อความที่แสดงให้ผู้ใช้
        options: const AuthenticationOptions(
          useErrorDialogs: true, // แสดงกล่องโต้ตอบข้อผิดพลาดของระบบ
          biometricOnly: false, // อนุญาต PIN/รูปแบบเป็นทางเลือกสำรอง
          stickyAuth: true, // ป้องกันแอปปิดระหว่างการยืนยันตัวตน
        ),
      );
      return authenticate;
    } on PlatformException catch (e) {
      // จัดการข้อผิดพลาดการยืนยันตัวตนเฉพาะแพลตฟอร์ม
      print(e);
      return false;
    }
  }

  // ฟังก์ชันเพื่อดึงสินค้าทั้งหมดจาก API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // อัปเดตสถานะด้วยข้อมูลสินค้าใหม่
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    }
  }

  // ฟังก์ชันเพื่อเพิ่มสินค้าใหม่
  void addProduct(int id, String name, double cost, int amount) async {
    try {
      // สร้างเนื้อหาคำขอด้วยข้อมูลสินค้า
      Map data = {
        'product_code': id,
        'product_name': name,
        'cost': cost,
        'amount': amount,
      };
      var body = jsonEncode(data);

      // ส่งคำขอ POST เพื่อสร้างสินค้า
      final response = await http.post(Uri.parse('$baseUrl/products/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body);

      if (response.statusCode == 201) {
        // รีเฟรชรายการสินค้าเมื่อสำเร็จ
        fetchProducts();
        // แสดงการแจ้งเตือนความสำเร็จ
        notify.showNotification('เพิ่มสินค้า', 'เพิ่มสินค้าสำเร็จแล้ว');
      } else {
        // แสดงการแจ้งเตือนข้อผิดพลาด
        notify.showNotification('ข้อผิดพลาด', 'ไม่สามารถเพิ่มสินค้า');
        throw Exception('ไม่สามารถเพิ่มสินค้า');
      }
    } catch (error) {
      // จัดการข้อผิดพลาดและแสดงการแจ้งเตือน
      notify.showNotification(
          'ข้อผิดพลาด', 'ไม่สามารถเพิ่มสินค้า: ${error.toString()}');
    }
  }

  // ฟังก์ชันเพื่ออัปเดตสินค้าที่มีอยู่
  void updateProduct(int id, String name, double cost, int amount) async {
    try {
      // สร้างเนื้อหาคำขอด้วยข้อมูลที่อัปเดต
      Map data = {
        'product_name': name,
        'cost': cost,
        'amount': amount,
      };
      var body = jsonEncode(data);

      // ส่งคำขอ PUT เพื่ออัปเดตสินค้า
      final response = await http.put(Uri.parse('$baseUrl/products/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        // รีเฟรชรายการสินค้าเมื่อสำเร็จ
        fetchProducts();
        // แสดงการแจ้งเตือนความสำเร็จ
        notify.showNotification('อัปเดตสินค้า', 'อัปเดตสินค้าสำเร็จแล้ว');
      } else {
        // แสดงการแจ้งเตือนข้อผิดพลาด
        notify.showNotification('ข้อผิดพลาด', 'ไม่สามารถอัปเดตสินค้า');
        throw Exception('ไม่สามารถอัปเดตสินค้า');
      }
    } catch (error) {
      // จัดการข้อผิดพลาดและแสดงการแจ้งเตือน
      notify.showNotification(
          'ข้อผิดพลาด', 'ไม่สามารถอัปเดตสินค้า: ${error.toString()}');
    }
  }

  // ฟังก์ชันเพื่อลบสินค้า
  void deleteProduct(int id) async {
    try {
      // ส่งคำขอ DELETE เพื่อลบสินค้า
      final response =
          await http.delete(Uri.parse('$baseUrl/products/$id'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        // รีเฟรชรายการสินค้าเมื่อสำเร็จ
        fetchProducts();
        // แสดงการแจ้งเตือนความสำเร็จ
        notify.showNotification('ลบสินค้า', 'ลบสินค้าสำเร็จแล้ว');
      } else {
        // แสดงการแจ้งเตือนข้อผิดพลาด
        notify.showNotification('ข้อผิดพลาด', 'ไม่สามารถลบสินค้า');
        throw Exception('ไม่สามารถลบสินค้า');
      }
    } catch (error) {
      // จัดการข้อผิดพลาดและแสดงการแจ้งเตือน
      notify.showNotification(
          'ข้อผิดพลาด', 'ไม่สามารถลบสินค้า: ${error.toString()}');
    }
  }

  // ฟังก์ชันเพื่อแสดงกล่องโต้ตอบสำหรับการเพิ่มหรือแก้ไขสินค้า
  void showProductForm(Product? product) {
    // กรอกช่องแบบฟอร์มล่วงหน้าหากกำลังแก้ไขสินค้าที่มีอยู่
    _idController.text = product?.productCode.toString() ?? '';
    _nameController.text = product?.productName ?? '';
    _costController.text = product?.cost.toString() ?? '';
    _amountController.text = product?.amount.toString() ?? '';

    // แสดงกล่องโต้ตอบพร้อมแบบฟอร์ม
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(product != null ? 'แก้ไขสินค้า' : 'เพิ่มสินค้า'),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // ช่อง ID (ปิดใช้งานเมื่อแก้ไข)
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    enabled: product == null, // เปิดใช้งานเฉพาะสำหรับสินค้าใหม่
                    decoration: InputDecoration(
                      labelText: 'รหัส',
                    ),
                  ),
                  // ช่องชื่อ
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อ',
                    ),
                  ),
                  // ช่องราคา
                  TextField(
                    controller: _costController,
                    decoration: InputDecoration(
                      labelText: 'ราคา',
                    ),
                  ),
                  // ช่องจำนวน
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                  ),
                ]),
              ),
            ),
            actions: [
              // ปุ่มยกเลิก
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ยกเลิก'),
              ),
              // ปุ่มบันทึก/อัปเดต
              TextButton(
                onPressed: () {
                  setState(() {
                    if (product == null) {
                      // เพิ่มสินค้าใหม่
                      addProduct(
                        int.parse(_idController.text),
                        _nameController.text,
                        double.parse(_costController.text),
                        int.parse(_amountController.text),
                      );
                      // ล้างช่องแบบฟอร์ม
                      _idController.clear();
                      _nameController.clear();
                      _costController.clear();
                      _amountController.clear();
                      Navigator.pop(context);
                    } else {
                      // อัปเดตสินค้าที่มีอยู่
                      updateProduct(
                        int.parse(_idController.text),
                        _nameController.text,
                        double.parse(_costController.text),
                        int.parse(_amountController.text),
                      );
                      // ล้างช่องแบบฟอร์ม
                      _idController.clear();
                      _nameController.clear();
                      _costController.clear();
                      _amountController.clear();
                      Navigator.pop(context);
                    }
                  });
                },
                child: Text(product != null ? 'อัปเดต' : 'บันทึก'),
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // UI หน้าจอหลัก
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการสินค้า'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ปุ่มเพิ่มสินค้า
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showProductForm(null); // แสดงแบบฟอร์มว่างสำหรับสินค้าใหม่
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'เพิ่มสินค้า',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // รายการสินค้า
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(), // เพิ่มเส้นคั่นระหว่างรายการ
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  // การแสดงข้อมูลสินค้า
                  title: Row(
                    children: [
                      // แสดงรหัสสินค้าในปุ่มสีเขียว
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          product.productCode.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(product.productName), // แสดงชื่อสินค้า
                    ],
                  ),
                  // รายละเอียดสินค้าเพิ่มเติม
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคา: ${product.cost}'),
                      Text('จำนวน: ${product.amount}'),
                    ],
                  ),
                  // ปุ่มแก้ไขและลบ
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ปุ่มแก้ไข
                      IconButton(
                        onPressed: () {
                          showProductForm(
                              product); // แสดงแบบฟอร์มพร้อมข้อมูลสินค้า
                        },
                        icon: Icon(Icons.edit),
                      ),
                      // ปุ่มลบพร้อมการยืนยันตัวตนทางชีวมิติ
                      IconButton(
                        onPressed: () async {
                          // ขอการยืนยันตัวตนทางชีวมิติก่อนลบ
                          bool authenticate = await _authenticate();

                          if (authenticate) {
                            // หากการยืนยันตัวตนสำเร็จ ให้แสดงกล่องโต้ตอบยืนยัน
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('ลบสินค้า'),
                                  content: Text(
                                      'คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteProduct(product.productCode);
                                        Navigator.pop(context);
                                      },
                                      child: Text('ลบ'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // แสดงข้อความหากการยืนยันตัวตนล้มเหลว
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'การยืนยันตัวตนล้มเหลวหรือถูกยกเลิก')),
                            );
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
