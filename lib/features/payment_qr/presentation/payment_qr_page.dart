import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class PaymentQRPage extends StatefulWidget {
  final int copyCount;

  const PaymentQRPage({super.key, this.copyCount = 1});

  @override
  State<PaymentQRPage> createState() => _PaymentQRPageState();
}

class _PaymentQRPageState extends State<PaymentQRPage> {
  static const int _initialCountdown = 5;
  static const Map<int, String> _qrImageByCopies = {
    1: 'assets/images/payment_qr1.JPG',
    2: 'assets/images/payment_qr2.jpg',
    3: 'assets/images/payment_qr3.jpg',
    4: 'assets/images/payment_qr4.jpg',
    5: 'assets/images/payment_qr5.jpg',
  };

    void _goBackCopiesSelection() {
    context.goNamed(AppRoutes.copiesSelection);
  }

  Timer? _timer;
  int _secondsLeft = _initialCountdown;

  bool get _isNextEnabled => _secondsLeft <= 0;
  String get _selectedQrAsset =>
      _qrImageByCopies[widget.copyCount] ?? _qrImageByCopies[1]!;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: _goBackCopiesSelection,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
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
            const SizedBox(height: 120),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Payment',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                    ),
                    Text(
                      'Press Next after paying.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Copies: ${widget.copyCount}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
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
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    child: Image.asset(
                      _selectedQrAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.only(bottom: 220),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isNextEnabled
                      ? () {
                          context.goNamed(
                            AppRoutes.captureConfirm,
                            extra: {'copyCount': widget.copyCount},
                          );
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
                          ? const Color(0xFFCFE3F1)
                          : const Color(0xFFB7C6D3),
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                    ),
                    child: Text(
                      _isNextEnabled ? 'Next' : 'Next ($_secondsLeft)',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromRGBO(36, 58, 94, 1),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
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