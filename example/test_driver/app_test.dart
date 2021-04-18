import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

final expectedData = {
  "MD5": "5d41402abc4b2a76b9719d911017c592",
  "SHA1": "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d",
  "SHA224": "ea09ae9cc6768c50fcee903ed054556e5bfc8347907f12598aa24193",
  "SHA256": "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824",
  "SHA384":
      "59e1748777448c69de6b800d7a33bbfb9ff1b463e44354c3553bcdb9c666fa90125a3c79f90397bdf5f6a13de828684f",
  "SHA512":
      "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043",
  "SHA512_TRUNC224": "fe8509ed1fb7dcefc27e6ac1a80eddbec4cb3d2c6fe565244374061c",
  "SHA512_TRUNC256":
      "e30d87cfa2a75db545eac4d61baf970366a8357c7f72fa95b52d0accb698f13a",
};

const int _kRetryTime = 3;
const Timeout _kTimeout = const Timeout(const Duration(seconds: 30));

void main() {
  group('digest verify', () {
    final hashFinder = find.text('Hash');
    final inputFinder = find.byValueKey('input');
    final resultFinder = find.byValueKey('result');
    final backFinder = find.byTooltip('Back');

    FlutterDriver? driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver?.close();
    });

    test('MD5', () async {
      await driver?.tap(hashFinder);
      String digest = 'MD5';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA1', () async {
      String digest = 'SHA1';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA224', () async {
      String digest = 'SHA224';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA256', () async {
      String digest = 'SHA256';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA384', () async {
      String digest = 'SHA384';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA512', () async {
      String digest = 'SHA512';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA512_TRUNC224', () async {
      String digest = 'SHA512_TRUNC224';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);

    test('SHA512_TRUNC256', () async {
      String digest = 'SHA512_TRUNC256';

      final digestFinder = find.text(digest);
      await driver?.tap(digestFinder);
      await driver?.tap(inputFinder);
      await driver?.enterText('hello');

      final diagnostics = await driver?.getWidgetDiagnostics(resultFinder);

      await expectLater(diagnostics.toString(), contains(expectedData[digest]));

      await driver?.tap(backFinder);
    }, retry: _kRetryTime);
  }, timeout: _kTimeout);
}
