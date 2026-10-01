import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virasat/widgets/cards/safe_product_image.dart';
import 'package:virasat/features/artisan/screens/my_artisan_products_screen.dart';

void main() {
  group('SafeProductImage Widget & MyArtisanProductsScreen Tests', () {
    testWidgets('SafeProductImage renders placeholder when imagePath is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SafeProductImage(
              imagePath: '',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(SafeProductImage), findsOneWidget);
      expect(find.text('VIRASAT Craft'), findsOneWidget);
    });

    testWidgets('SafeProductImage handles invalid asset path without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SafeProductImage(
              imagePath: 'assets/images/crafts/non_existent_image_123.jpg',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(SafeProductImage), findsOneWidget);
    });

    testWidgets('SafeProductImage handles network URL scheme without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SafeProductImage(
              imagePath: 'https://example.com/craft_image.jpg',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(SafeProductImage), findsOneWidget);
    });

    testWidgets('MyArtisanProductsScreen renders successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyArtisanProductsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('My Artisan Products'), findsOneWidget);
      expect(find.byType(MyArtisanProductsScreen), findsOneWidget);
    });
  });
}
