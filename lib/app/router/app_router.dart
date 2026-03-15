import 'package:go_router/go_router.dart';

import '../../features/capture/presentation/capture_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/layout/presentation/layout_page.dart';
import '../../features/layout/presentation/layout_page2.dart';
import '../../features/payment_qr/presentation/payment_qr_page.dart';
import '../../features/picture_qr/presentation/picture_qr_page.dart';
import '../../features/print/presentation/print_preview_page.dart';
import '../../features/result_preview/presentation/result_preview_page.dart';

class AppRoutes {
  static const home = 'home';
  static const capture = 'capture';
  static const printPreview = 'printPreview';
  static const paymentQR = 'paymentQR';
  static const layout = 'layout';
  static const layout2 = 'layout2';
  static const pictureQR = 'pictureQR';
  static const resultPreview = 'resultPreview';
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
        path: '/capture',
        name: AppRoutes.capture,
        builder: (context, state) {
          final selectedFrame = state.extra as String?;
          return CapturePage(selectedFrame: selectedFrame);
        },
      ),
      GoRoute(
        path: '/print-preview',
        name: AppRoutes.printPreview,
        builder: (context, state) {
          final imagePath = state.extra as String?;
          return PrintPreviewPage(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: '/payment-qr',
        name: AppRoutes.paymentQR,
        builder: (context, state) => const PaymentQRPage(),
      ),
      GoRoute(
        path: '/layout',
        name: AppRoutes.layout,
        builder: (context, state) => const LayoutPage(),
      ),
      GoRoute(
        path: '/layout2',
        name: AppRoutes.layout2,
        builder: (context, state) {
          final selectedFrame = state.extra as String?;
          return LayoutPage2(selectedFrame: selectedFrame);
        },
      ),
      GoRoute(
        path: '/picture-qr',
        name: AppRoutes.pictureQR,
        builder: (context, state) => const PictureQRPage(),
      ),
      GoRoute(
        path: '/result-preview',
        name: AppRoutes.resultPreview,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final images = extra['images'] as List<String>? ?? [];
          final frame = extra['frame'] as String?;
          return ResultPreviewPage(images: images, selectedFrame: frame);
        },
      ),
    ],
  );
}
