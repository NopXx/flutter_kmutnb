// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  File? _image; // Declare image file variable
  String? _qrCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Gallery QR Code'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Add image preview
              _image != null
                  ? Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Image.file(_image!,
                          height: 300, width: 300, fit: BoxFit.cover),
                    )
                  : Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('No image selected'),
                      ),
                    ),
              // Add image picker button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image from gallery
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() => _image = File(image.path));
                  }
                },
                child: const Text('Choose from Gallery'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                    try {
                      var result = await BarcodeScanner.scan();
                      setState(() => _qrCode = result.rawContent);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('QR Code: ${result.rawContent}')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                },
                child: const Text('Scan QR Code'),
              ),
              const SizedBox(height: 20),
              Text(_qrCode?? 'No QR code detected'),
            ],
          ),
        ),
      ),
    );
  }
}
