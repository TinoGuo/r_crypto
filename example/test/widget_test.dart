// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:r_crypto_example/data.dart';
import 'package:r_crypto_example/hash.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var expectedData = {
    "MD5": "5d41402abc4b2a76b9719d911017c592",
    "SHA1": "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d",
    "SHA224": "ea09ae9cc6768c50fcee903ed054556e5bfc8347907f12598aa24193",
    "SHA256":
        "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824",
    "SHA384":
        "59e1748777448c69de6b800d7a33bbfb9ff1b463e44354c3553bcdb9c666fa90125a3c79f90397bdf5f6a13de828684f",
    "SHA512":
        "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043",
    "SHA512_TRUNC224":
        "fe8509ed1fb7dcefc27e6ac1a80eddbec4cb3d2c6fe565244374061c",
    "SHA512_TRUNC256":
        "e30d87cfa2a75db545eac4d61baf970366a8357c7f72fa95b52d0accb698f13a",
  };

  list.forEach((element) {
    testWidgets('Verify Widget ${element.name} Result',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: HashDataScreen(profileData: element)));

      final titleFinder = find.text(element.name);
      expect(titleFinder, findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hello');

      final resultFinder = find.text(expectedData[element.name]!);

      await tester.pump();

      expect(resultFinder, findsOneWidget);
    });
  });
}
