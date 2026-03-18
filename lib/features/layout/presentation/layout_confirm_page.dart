import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class LayoutConfirmPage extends StatefulWidget {
  final String? selectedFrame;

  const LayoutConfirmPage({
    super.key,
    this.selectedFrame,
  });

  @override
  State<LayoutConfirmPage> createState() => _LayoutConfirmState();
}

class _LayoutConfirmState extends State<LayoutConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Top Text Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'แต่ละรูปจะมีเวลา 5 วินาที',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                  ),
                  Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ถ้าพร้อมแล้วกด ',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.black,
                                  fontSize: 20,
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
                          width: 384,
                          height: 768,
                        )
                      : Container(
                          width: 384,
                          height: 768,
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
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to capture with selected frame
                    context.goNamed(AppRoutes.capture, extra: widget.selectedFrame);
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