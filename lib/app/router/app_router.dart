import 'package:go_router/go_router.dart';

import '../../features/capture/presentation/capture_confirm_page.dart';
import '../../features/capture/presentation/capture_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/payment_qr/presentation/payment_qr_page.dart';
import '../../features/result_preview/presentation/result_download_qr_page.dart';
import '../../features/result_preview/presentation/result_preview_page.dart';

class AppRoutes {
  static const home = 'home';
  static const captureConfirm = 'captureConfirm';
  static const capture = 'capture';
  static const printPreview = 'printPreview';
  static const paymentQR = 'paymentQR';
  static const resultPreview = 'resultPreview';
  static const resultDownloadQr = 'resultDownloadQr';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/capture-confirm',
        name: AppRoutes.captureConfirm,
        builder: (context, state) => const CaptureConfirmPage(),
      ),
      GoRoute(
        path: '/capture',
        name: AppRoutes.capture,
        builder: (context, state) => const CapturePage(),
      ),
      GoRoute(
        path: '/payment-qr',
        name: AppRoutes.paymentQR,
        builder: (context, state) => const PaymentQRPage(),
      ),
      GoRoute(
        path: '/result-preview',
        name: AppRoutes.resultPreview,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final images = extra['images'] as List<String>? ?? [];
          final captureAspectRatio = (extra['captureAspectRatio'] as num?)?.toDouble();
          return ResultPreviewPage(
            images: images,
            captureAspectRatio: captureAspectRatio,
          );
        },
      ),
      GoRoute(
        path: '/result-download-qr',
        name: AppRoutes.resultDownloadQr,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final downloadUrl = extra['downloadUrl'] as String? ?? '';
          return ResultDownloadQrPage(
            downloadUrl: downloadUrl,
          );
        },
      ),
    ],
  );
}
