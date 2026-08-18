import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/router/app_router.dart';

class ResultDownloadQrPage extends StatefulWidget {
  final String downloadUrl;

  const ResultDownloadQrPage({
    super.key,
    required this.downloadUrl,
  });

  @override
  State<ResultDownloadQrPage> createState() => _ResultDownloadQrPageState();
}

class _ResultDownloadQrPageState extends State<ResultDownloadQrPage> {
  bool _hasNavigatedHome = false;

  void _goHome() {
    if (_hasNavigatedHome || !mounted) {
      return;
    }

    _hasNavigatedHome = true;
    context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = widget.downloadUrl.trim().isNotEmpty;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
            child: Column(
              children: [
                const SizedBox(height: 64),
                Text(
                  'Scan To Download',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Picture ready to download',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 24,
                            offset: Offset(0, 10),
                            color: Color(0x33000000),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasUrl)
                            QrImageView(
                              data: widget.downloadUrl,
                              size: 260,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                            )
                          else
                            const Icon(
                              Icons.qr_code_2_rounded,
                              size: 220,
                              color: Colors.black54,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            hasUrl
                                ? 'This QR is for download picture '
                                : 'ไม่พบลิงก์ดาวน์โหลดภาพ',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                padding: const EdgeInsets.only(bottom: 140),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _goHome,
                      borderRadius: BorderRadius.circular(90),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 18,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(143, 182, 216, 1),
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      child: Text(
                        'END',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color.fromRGBO(36, 58, 94, 1),
                          fontWeight: FontWeight.w900,
                          fontSize: 42,
                        ),
                      ),
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
