@Timeout(Duration(milliseconds: 500))

import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String hardcoded', () {
    test('test localization string hardcoded', () {
      expect('', ''.hardcoded);
    });
  });
}
