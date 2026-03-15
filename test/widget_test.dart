import 'package:flutter_test/flutter_test.dart';

import 'package:receiptphotobooth/app/app.dart';

void main() {
  testWidgets('home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ReceiptPhotoBoothApp());
    await tester.pumpAndSettle();

    expect(find.text('Receipt Photo Booth'), findsOneWidget);
    expect(find.text('Take Picture'), findsOneWidget);
  });
}
