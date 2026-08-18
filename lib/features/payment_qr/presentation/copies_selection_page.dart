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
  static const List<int> _priceOptions = [29, 55, 79, 105, 135];

  int _selectedCopies = 1;

  String _copyLabel(int copies) => copies == 1 ? '1 copy' : '$copies copies';
  String _priceLabel(int copies) => '${_priceOptions[_copyOptions.indexOf(copies)]} THB';

  void _goBackHome() {
    context.goNamed(AppRoutes.home);
  }

  void _goToPayment() {
    context.goNamed(
      AppRoutes.paymentQR,
      extra: {'copyCount': _selectedCopies},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: _goBackHome,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
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
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Choose Copies',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 52,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.separated(
                    itemCount: _copyOptions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final copies = _copyOptions[index];
                      final isSelected = copies == _selectedCopies;

                      return Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Material(
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
                                  color: isSelected
                                      ? const Color.fromRGBO(143, 182, 216, 1)
                                      : Colors.white.withValues(alpha: 0.88),
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _copyLabel(copies),
                                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 28,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _priceLabel(copies),
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: Colors.black87,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  isSelected ? 'Selected' : 'Tap to select',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.black,
                                                  size: 26,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child:  Padding(
                  padding: const EdgeInsets.only(bottom: 180),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _goToPayment,
                      borderRadius: BorderRadius.circular(90),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 64,
                          vertical: 18,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(143, 182, 216, 1),
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            color: const Color.fromRGBO(36, 58, 94, 1),
                            width: 4,
                          ),
                        ),
                        child: Text(
                          'Next',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: const Color.fromRGBO(36, 58, 94, 1),
                            fontSize: 42,
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
        ),
      ),
    );
  }
}