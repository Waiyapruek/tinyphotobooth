import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class LayoutPage2 extends StatefulWidget {
  final String? selectedFrame;

  const LayoutPage2({
    super.key,
    this.selectedFrame,
  });

  @override
  State<LayoutPage2> createState() => _LayoutPage2State();
}

class _LayoutPage2State extends State<LayoutPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: 1668,
        height: 2388,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.contain,
            onError: (exception, stackTrace) {
              // Fallback if image not found
            },
          ),
        ),
        child: Column(
          children: [
            // Top Text Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'แต่ละรูปจะมีเวลา 3 วินาที',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ถ้าพร้อมแล้วกด ',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                  )
                ],
              ),
            ),
            // Display Selected Frame Image
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.selectedFrame != null
                      ? Image.asset(
                          widget.selectedFrame!,
                          fit: BoxFit.contain,
                          width: 480,
                          height: 600,
                        )
                      : Container(
                          width: 480,
                          height: 600,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'No frame selected',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to capture with selected frame
                    context.goNamed(AppRoutes.capture);
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 28,
                        ),
                      ],
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