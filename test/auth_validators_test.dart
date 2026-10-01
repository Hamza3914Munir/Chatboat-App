import 'package:facepix/core/validation/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email', () {
    test('rejects empty and malformed addresses', () {
      expect(AuthValidators.email(null), isNotNull);
      expect(AuthValidators.email(''), isNotNull);
      expect(AuthValidators.email('   '), isNotNull);
      expect(AuthValidators.email('not-an-email'), isNotNull);
      expect(AuthValidators.email('missing@domain'), isNotNull);
      expect(AuthValidators.email('@facepix.ai'), isNotNull);
      expect(AuthValidators.email('two spaces@facepix.ai'), isNotNull);
    });

    test('accepts ordinary addresses', () {
      expect(AuthValidators.email('hello@facepix.ai'), isNull);
      expect(AuthValidators.email('  hello@facepix.ai  '), isNull);
      expect(AuthValidators.email('first.last+tag@sub.example.co.uk'), isNull);
    });
  });

  group('password', () {
    test('enforces the length the helper text promises', () {
      expect(AuthValidators.password(''), isNotNull);
      expect(AuthValidators.password('abc'), isNotNull);
      expect(AuthValidators.password('1234567'), isNotNull);
      expect(AuthValidators.password('12345678'), isNull);
    });

    test('login does not impose the sign-up length rule', () {
      expect(AuthValidators.loginPassword(''), isNotNull);
      expect(AuthValidators.loginPassword('short'), isNull);
    });
  });

  group('confirmPassword', () {
    test('must match the original', () {
      final confirm = AuthValidators.confirmPassword(() => 'correct-horse');
      expect(confirm(''), isNotNull);
      expect(confirm('something-else'), isNotNull);
      expect(confirm('correct-horse'), isNull);
    });

    test('tracks later edits to the original field', () {
      var current = 'first';
      final confirm = AuthValidators.confirmPassword(() => current);
      expect(confirm('first'), isNull);
      current = 'changed';
      expect(confirm('first'), isNotNull);
      expect(confirm('changed'), isNull);
    });
  });

  group('fullName', () {
    test('rejects blank and single characters', () {
      expect(AuthValidators.fullName(''), isNotNull);
      expect(AuthValidators.fullName('   '), isNotNull);
      expect(AuthValidators.fullName('H'), isNotNull);
      expect(AuthValidators.fullName('Hamza Munir'), isNull);
    });
  });
}
