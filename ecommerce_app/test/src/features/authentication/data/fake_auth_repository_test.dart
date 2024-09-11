import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final testUser =
      AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);

  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final repo = FakeAuthRepository();
      expect(repo.currentUser, null);
      expect(repo.authStateChanges(), emits(null));
    });

    test('currentUser is not null after signIn', () async {
      final repo = FakeAuthRepository();
      await repo.signInWithEmailAndPassword(testEmail, testPassword);
      expect(repo.currentUser, testUser);
    });

    test('currentUser is not null after registration', () async {
      final repo = FakeAuthRepository();
      await repo.createUserWithEmailAndPassword(testEmail, testPassword);
      expect(repo.currentUser, testUser);
    });

    test('currentUser is null after signOut', () async {
      final repo = FakeAuthRepository();
      await repo.createUserWithEmailAndPassword(testEmail, testPassword);
      expect(repo.currentUser, testUser);
      await repo.signOut();
      expect(repo.currentUser, null);
      expect(repo.authStateChanges(), emits(null));
    });

    test('signIn after dispose throws exception', () async {
      final repo = FakeAuthRepository();
      repo.dispose();
      expect(() => repo.signInWithEmailAndPassword(testEmail, testPassword),
          throwsStateError);
    });
  });
}
