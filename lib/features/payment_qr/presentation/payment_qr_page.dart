import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class PaymentQRPage extends StatefulWidget {
  const PaymentQRPage({super.key});

  @override
  State<PaymentQRPage> createState() => _PaymentQRPageState();
}

class _PaymentQRPageState extends State<PaymentQRPage> {
  static const int _initialCountdown = 5;
  Timer? _timer;
  int _secondsLeft = _initialCountdown;

  bool get _isNextEnabled => _secondsLeft <= 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsLeft <= 1) {
        setState(() {
          _secondsLeft = 0;
        });
        timer.cancel();
        return;
      }

      setState(() {
        _secondsLeft--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.cover,
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
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Payment',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 56,
                        ),
                  ),
                  Text(
                    'เมื่อชำระเงินเรียบร้อยแล้ว กด Next',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
              child: Center(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(24), // Optional: rounded corners
                child: SizedBox(
                  child: Image.asset(
                  'assets/images/payment_qr.JPG',
                  fit: BoxFit.contain, // Crops the image to fill the box
                ),
                ),
                ),
              ),
            ),      // Center Bottom Button
            const SizedBox(height: 48),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 140),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isNextEnabled
                        ? () {
                            context.goNamed(AppRoutes.captureConfirm);
                          }
                        : null,
                    borderRadius: BorderRadius.circular(90),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 18,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: _isNextEnabled
                            ? const Color(0xFFFEF2D5)
                            : const Color(0xFFD7D1C2),
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      child: Text(
                        _isNextEnabled ? 'Next' : 'Next ($_secondsLeft)',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.black,
                              fontSize: 42,
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