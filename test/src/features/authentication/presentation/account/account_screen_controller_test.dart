import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  late FakeAuthRepository mockAuthRepository;

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
  });
  group(
    'AccountScreenController ',
    () {
      test('initial value of accountScreenController with AsyncData(null)', () {
        final controller = AccountScreenController(authRepository: mockAuthRepository);
        expect(controller.debugState, const AsyncData<void>(null));
      });

      test('signOut success', () async {
        // setup
        final controller = AccountScreenController(authRepository: mockAuthRepository);
        when(mockAuthRepository.signOut).thenAnswer((_) => Future.value());
        // run
        await controller.signOut();
        // verify
        verify(mockAuthRepository.signOut).called(1);
        expect(controller.debugState, const AsyncData<void>(null));
      });

      test('signOut Failure', () async {
        // setup
        final controller = AccountScreenController(authRepository: mockAuthRepository);
        when(mockAuthRepository.signOut).thenThrow(Exception('Connection Failed'));
        //run
        await controller.signOut();
        //verify
        verify(mockAuthRepository.signOut);
        expect(controller.debugState.hasError, true);
        expect(controller.debugState, isA<AsyncError>());
      });
    },
  );
}
