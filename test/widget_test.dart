import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virasat/main.dart';

void main() {
  testWidgets('Virasat App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VirasatApp(),
      ),
    );
    expect(find.byType(VirasatApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
