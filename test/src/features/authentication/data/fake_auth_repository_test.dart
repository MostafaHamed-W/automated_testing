import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final AppUser testUser = AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);

  setUpAll(() {
    fakeAuthRepository = FakeAuthRepository();
  });

  group(
    'Test FakeAuthRepository',
    () {
      test('get current user and userAuthStete changes when it is null', () {
        expect(fakeAuthRepository.currentUser, null);
        expect(fakeAuthRepository.authStateChanges(), emits(null));
      });

      test('get current user and userAuthStete changes when it is testUser ', () async {
        await fakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword);
        expect(fakeAuthRepository.currentUser, testUser);
        expect(fakeAuthRepository.authStateChanges(), emits(testUser));
      });

      test('get current user and userAuthStete changes when it is testUser after register ',
          () async {
        await fakeAuthRepository.signOut();
        await fakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword);
        expect(fakeAuthRepository.currentUser, testUser);
        expect(fakeAuthRepository.authStateChanges(), emits(testUser));
      });

      test('user is null after signOut', () async {
        await fakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword);
        // Note that emitsInOrder if before the sign out
        // we should listen to stream before doing action
        // because behaviout subject remember only the last value
        // if we move the expect after the signOut test will fail
        expect(fakeAuthRepository.authStateChanges(), emitsInOrder([testUser, null]));
        await fakeAuthRepository.signOut();
        expect(fakeAuthRepository.currentUser, null);
      });

      // or we can do it like this
      test('user is null after signOut', () async {
        await fakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword);
        expect(fakeAuthRepository.currentUser, testUser);
        expect(fakeAuthRepository.authStateChanges(), emits(testUser));
        await fakeAuthRepository.signOut();
        expect(fakeAuthRepository.currentUser, null);
        expect(fakeAuthRepository.authStateChanges(), emits(null));
      });

      tearDownAll(() => fakeAuthRepository.dispose());
    },
  );
}
