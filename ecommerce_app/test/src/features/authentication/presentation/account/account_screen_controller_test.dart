import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {

late MockAuthRepository repo;
late AccountScreenController controller;

setUp((){
  repo = MockAuthRepository();
  controller = AccountScreenController(authRepository: repo);
});

  group('AccountScreenController', () {
    test('initial state is AsyncValue.data(null)', () {
      verifyNever(repo.signOut);
      expect(controller.state, const AsyncValue<void>.data(null));
    });

    test('signOut success', () async {
      // setup
      when(repo.signOut).thenAnswer((_) => Future.value());
      // run
      await controller.signOut();
      //verify
      expect(controller.state, const AsyncData<void>(null));
      verify(repo.signOut).called(1);
    });

    test('signOut failure', () async {
      // setup
      final exception = Exception('Connection failed');
      when(repo.signOut).thenThrow((_) => exception);
      // run
      await controller.signOut();
      //verify
      expect(controller.state.hasError, true);
      verify(repo.signOut).called(1);
    });
  });
}
