import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  late PageController _pageController;
  int currentPreviewIndex = 0;

  // Sample image paths - replace with your actual images
  final List<String> imagePaths = [
    'assets/images/frame1.png',
    'assets/images/frame2.png',
    'assets/images/frame3.png',
  ];

  String get _selectedFrameName {
    return imagePaths[currentPreviewIndex];
  }

  @override
  void initState() {
    super.initState();
    // Initialize at a large offset so looping works both directions
    _pageController = PageController(initialPage: 10000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPreview() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _previousPreview() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Frame',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'เลือกรูปแบบและ กด Next',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
            // Picture carousel with navigation
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left arrow button
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 32,
                      onPressed: _previousPreview,
                    ),
                    // Picture carousel area
                    SizedBox(
                      width: 240,
                      height: 480,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPreviewIndex = index % imagePaths.length;
                          });
                        },
                        itemCount: 20000,
                        itemBuilder: (context, index) {
                          final imageIndex = index % imagePaths.length;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imagePaths[imageIndex],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    // Right arrow button
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 32,
                      onPressed: _nextPreview,
                    ),
                  ],
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
                    // Navigate to layout2 with selected frame
                    context.goNamed(AppRoutes.layout2, extra: _selectedFrameName);
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
                      'Next',
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
          ],
        ),
      ),
    );
  }
}
