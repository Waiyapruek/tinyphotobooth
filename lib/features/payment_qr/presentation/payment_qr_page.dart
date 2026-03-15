import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class PaymentQRPage extends StatelessWidget {
  const PaymentQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        padding: const EdgeInsets.all(16.0),
        width: 1668,
        height: 2388,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.contain,
            onError: (exception, stackTrace) {
              // Fallback if image not found
            },
          ),
        ),
        child: Column(
          children: [
            // Top Text Lines
            Align(alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Payment',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'เมื่อชำระเงินเรียบร้อยแล้ว กด Next',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
          ),            // Center QR Code
            Expanded(
              child: Center(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(24), // Optional: rounded corners
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: Image.asset(
                  'assets/images/test_payment_qr.jpg',
                  width: 500,
                  height: 500,
                  fit: BoxFit.cover, // Crops the image to fill the box
                ),
                ),
                ),
              ),
            ),      // Center Bottom Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Add navigation or action here
                      context.goNamed(AppRoutes.layout);
                    },
                    borderRadius: BorderRadius.circular(90),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 18,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2D5),
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}