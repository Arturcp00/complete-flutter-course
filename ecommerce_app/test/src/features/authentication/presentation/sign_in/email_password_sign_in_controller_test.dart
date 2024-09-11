import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';

  group('submit', () {
    test('''
    Given formType is signIn
    When signInWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
    ''', () async {
      final authRepository = MockAuthRepository();
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());

      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn);

      expectLater(controller.stream, emitsInOrder([
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.signIn,
          value: AsyncLoading<void>()
        ),
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.signIn,
          value: AsyncData<void>(null),
        ),
      ]));
      final result = await controller.submit(testEmail, testPassword);
      expect(result, true);
    }, timeout: Timeout(Duration(milliseconds: 500)));
  });

  group('updateFormType', () {
    test('''
    Given formType is signIn
    When signInWithEmailAndPassword fails
    Then return false
    And state is AsyncError
    ''', () async {
      final authRepository = MockAuthRepository();
      final exception = Exception('Couldnt sign in');
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenThrow((_) => exception);

      final controller = EmailPasswordSignInController(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn);

      expectLater(controller.stream, emitsInOrder([
        EmailPasswordSignInState(
          formType: EmailPasswordSignInFormType.signIn,
          value: AsyncLoading<void>()
        ),
        predicate<EmailPasswordSignInState>((state) {
          expect(state.formType, EmailPasswordSignInFormType.signIn);
          expect(state.value.hasError, true);
          return true;
        })
      ]));
      final result = await controller.submit(testEmail, testPassword);
      expect(result, false);
    }, timeout: Timeout(Duration(milliseconds: 500)));
  });

}
