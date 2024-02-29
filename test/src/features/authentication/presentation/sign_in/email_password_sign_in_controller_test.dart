@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final AppUser testUser = AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);

  late FakeAuthRepository fakeAuthRepository;
  setUpAll(() {
    fakeAuthRepository = MockAuthRepository();
  });

  group(
    'test submit in EmailPasswordSignInController',
    () {
      test(
        """
given form type is signIn
when signIn operation success
then return true
state is AsyncData """,
        () async {
          // setup
          when((() => fakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword)))
              .thenAnswer((_) => Future.value());
          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn,
            authRepository: fakeAuthRepository,
          );

          //verify
          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncLoading<void>(),
                ),
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncData<void>(null),
                )
              ],
            ),
          );

          // run
          final result = await controller.submit(testEmail, testPassword);
          expect(result, true);
        },
      );

      test(
        """
given form type is signIn
when signIn operation failure
then return false
state is AsyncError """,
        () async {
          // setup
          when((() => fakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword)))
              .thenThrow(Exception('Failed to connect'));
          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn,
            authRepository: fakeAuthRepository,
          );

          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncLoading<void>(),
                ),
                predicate<EmailPasswordSignInState>((state) {
                  expect(state.formType, EmailPasswordSignInFormType.signIn);
                  expect(state.value.hasError, true);

                  return true;
                })
              ],
            ),
          );
          // run
          final result = await controller.submit(testEmail, testPassword);

          //verify
          expect(result, false);
        },
      );

      test(
        """
given form type is signIn
when signIn operation success
then return true
state is AsyncData """,
        () async {
          // setup
          when((() => fakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword)))
              .thenAnswer((_) => Future.value());
          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: fakeAuthRepository,
          );

          //verify
          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncLoading<void>(),
                ),
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncData<void>(null),
                )
              ],
            ),
          );

          // run
          final result = await controller.submit(testEmail, testPassword);
          expect(result, true);
        },
      );

      test(
        """
given form type is signIn
when signIn operation failure
then return false
state is AsyncError """,
        () async {
          // setup
          when((() => fakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword)))
              .thenThrow(Exception('Failed to connect'));
          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: fakeAuthRepository,
          );

          expectLater(
            controller.stream,
            emitsInOrder(
              [
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncLoading<void>(),
                ),
                predicate<EmailPasswordSignInState>((state) {
                  expect(state.formType, EmailPasswordSignInFormType.register);
                  expect(state.value.hasError, true);

                  return true;
                })
              ],
            ),
          );
          // run
          final result = await controller.submit(testEmail, testPassword);

          //verify
          expect(result, false);
        },
      );
    },
  );

  group(
    'update form type methods',
    () {
      test("""update form type to register successfully
      with giver formtype of signIn

       """, () {
        // setUp
        final controller = EmailPasswordSignInController(
          authRepository: fakeAuthRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );

        // run
        controller.updateFormType(EmailPasswordSignInFormType.register);

        // verify
        expect(
            controller.debugState,
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null),
            ));
      });
    },
  );
}
