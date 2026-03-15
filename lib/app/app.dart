import 'package:flutter/material.dart';

import 'router/app_router.dart';
import '../core/theme/app_theme.dart';

class ReceiptPhotoBoothApp extends StatelessWidget {
  const ReceiptPhotoBoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Receipt Photo Booth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
