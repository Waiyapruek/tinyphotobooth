import 'package:go_router/go_router.dart';

import '../../features/capture/presentation/capture_confirm_page.dart';
import '../../features/capture/presentation/capture_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/payment_qr/presentation/payment_qr_page.dart';
import '../../features/payment_qr/presentation/copies_selection_page.dart';
import '../../features/result_preview/presentation/result_download_qr_page.dart';
import '../../features/result_preview/presentation/result_preview_page.dart';

class AppRoutes {
  static const home = 'home';
  static const copiesSelection = 'copiesSelection';
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
        path: '/copies-selection',
        name: AppRoutes.copiesSelection,
        builder: (context, state) => const CopiesSelectionPage(),
      ),
      GoRoute(
        path: '/capture-confirm',
        name: AppRoutes.captureConfirm,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final copyCount = (extra['copyCount'] as num?)?.toInt() ?? 1;
          return CaptureConfirmPage(copyCount: copyCount);
        },
      ),
      GoRoute(
        path: '/capture',
        name: AppRoutes.capture,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final copyCount = (extra['copyCount'] as num?)?.toInt() ?? 1;
          return CapturePage(copyCount: copyCount);
        },
      ),
      GoRoute(
        path: '/payment-qr',
        name: AppRoutes.paymentQR,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final copyCount = (extra['copyCount'] as num?)?.toInt() ?? 1;
          return PaymentQRPage(copyCount: copyCount);
        },
      ),
      GoRoute(
        path: '/result-preview',
        name: AppRoutes.resultPreview,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final images = extra['images'] as List<String>? ?? [];
          final captureAspectRatio = (extra['captureAspectRatio'] as num?)?.toDouble();
          final copyCount = (extra['copyCount'] as num?)?.toInt() ?? 1;
          return ResultPreviewPage(
            images: images,
            captureAspectRatio: captureAspectRatio,
            copyCount: copyCount,
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
