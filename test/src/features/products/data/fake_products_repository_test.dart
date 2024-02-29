import 'dart:math';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeProductsRepository fakeProductsRepository;
  setUpAll(() {
    fakeProductsRepository = FakeProductsRepository();
  });

  group(
    'Test Prodcuts',
    () {
      test('get procuts list funtion', () {
        expect(fakeProductsRepository.getProductsList(), kTestProducts);
      });

      test('get product with id', () {
        expect(fakeProductsRepository.getProduct('1'), kTestProducts[0]);
      });

      test('get product with id when throw error', () {
        expect(
          () =>
              fakeProductsRepository.getProduct('100'), // note that : don't forget the closure ()=>
          throwsStateError,
        );
      });

      test('fetch products list in future', () async {
        final result = await fakeProductsRepository.fetchProductsList();
        expect(result, kTestProducts);
      });

      test('watch proucts list', () {
        expect(
          fakeProductsRepository.watchProductsList(),
          emits(kTestProducts),
        );
      });

      test('watch product with id', () {
        expect(
          fakeProductsRepository.watchProduct('1'),
          emits(kTestProducts[0]),
        );
      });
    },
  );
}
