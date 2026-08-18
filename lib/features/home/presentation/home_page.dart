import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home_page.PNG'),
            fit: BoxFit.cover,
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
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 46),
                  Text(
                    'Receipt photo',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                        ),
                  ),
                  Text(
                    '@MFU Club Fair',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Image.asset(
                    'assets/images/Examplephotobooth.PNG',
                    width: 300,
                  ),
                ],
              ),
            ),
          ),
            // Center Bottom Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 240),
                child: ElevatedButton(
                  onPressed: () {
                    // Add navigation or action here
                    context.goNamed(AppRoutes.copiesSelection);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(143, 182, 216, 1),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90),
                      side: const BorderSide(
                        color: const Color.fromRGBO(36, 58, 94, 1),
                        width: 4,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color.fromRGBO(36, 58, 94, 1),
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
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