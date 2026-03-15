import 'package:flutter/material.dart';

class PictureQRPage extends StatelessWidget {
  const PictureQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture QR'),
      ),
      body: const Center(
        child: Text('Picture QR Screen'),
      ),
    );
  }
}
