import 'package:flutter/material.dart';
import 'package:lab2/pages/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productNo;
  final Product product;
  const ProductDetailScreen({super.key, required this.productNo, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Index $productNo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.inversePrimary,
            border: Border.all(color: Colors.black),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 10),
                color: Colors.black12,
                blurRadius: 2,
              ),
            ]
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product.productName),
              Text('Price: ${product.price.toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}