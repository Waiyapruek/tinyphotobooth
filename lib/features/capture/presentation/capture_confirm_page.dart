import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';

class CaptureConfirmPage extends StatelessWidget {
  final int copyCount;

  const CaptureConfirmPage({super.key, this.copyCount = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ready to Capture',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 44,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'it\'ll take 2 photos\nwith 5 seconds between each',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'and print out $copyCount copy(ies)',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'If you are ready press  ',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/Examplephotobooth.PNG',
                    fit: BoxFit.contain,
                    width: 384,
                    height: 768,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(bottom: 140),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.goNamed(
                      AppRoutes.capture,
                      extra: {'copyCount': copyCount},
                    );
                  },
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
                    child: const Icon(
                      Icons.camera_alt,
                      color: const Color.fromRGBO(36, 58, 94, 1),
                      size: 54,
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