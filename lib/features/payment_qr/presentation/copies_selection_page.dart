import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';

class CopiesSelectionPage extends StatefulWidget {
  const CopiesSelectionPage({super.key});

  @override
  State<CopiesSelectionPage> createState() => _CopiesSelectionPageState();
}

class _CopiesSelectionPageState extends State<CopiesSelectionPage> {
  static const List<int> _copyOptions = [1, 2, 3, 4, 5];

  int _selectedCopies = 1;

  String _copyLabel(int copies) => copies == 1 ? '1 copy' : '$copies copies';

  void _goToPayment() {
    context.goNamed(
      AppRoutes.paymentQR,
      extra: {'copyCount': _selectedCopies},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Choose Copies',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 52,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'เลือกจำนวนสำเนาที่จะพิมพ์',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView.separated(
                    itemCount: _copyOptions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final copies = _copyOptions[index];
                      final isSelected = copies == _selectedCopies;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCopies = copies;
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFF6DE) : Colors.white.withValues(alpha: 0.88),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.black54,
                                width: isSelected ? 4 : 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                  color: Color(0x22000000),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.black : const Color(0xFFFEF2D5),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$copies',
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _copyLabel(copies),
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 28,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isSelected ? 'Selected' : 'Tap to select',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.black,
                                    size: 34,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _goToPayment,
                    borderRadius: BorderRadius.circular(90),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
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
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.black,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}