import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1668,
        height: 2388,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home_page.PNG'),
            fit: BoxFit.contain,
            onError: (exception, stackTrace) {
              // Fallback if image not found
            },
          ),
        ),
        child: Stack(
          children: [
            // Top Text Lines
            Align(alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'TINY\nPHOTOBOOTH',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 52,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Receipt photo\n@มาลองเต๊อะคราฟท์\nริมคลอง x hands on',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                  ),
                ],
              ),
            ),
          ),
            // Center Bottom Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 160),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Add navigation or action here
                      context.goNamed(AppRoutes.paymentQR);
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
                        'Start',
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