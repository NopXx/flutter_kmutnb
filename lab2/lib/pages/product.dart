import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab2/pages/product_detail.dart';

class Product {
  final String productName;
  final int price;

  const Product(this.productName, this.price);
}

// ignore: must_be_immutable
class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  List colors = [Colors.blueGrey[100], Colors.blue[100]];
  final List<Product> products = List.generate(
      20, (index) => Product('Product $index', Random().nextInt(10) * 100));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                          productNo: index.toString(), product: product)));
            },
            child: ListTile(
              tileColor: colors[index % colors.length],
              title: Text(product.productName),
              subtitle: Text(product.price.toStringAsFixed(2)),
            ),
          );
        },
      ),
    );
  }
}
