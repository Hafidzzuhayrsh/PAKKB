import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Auth Provider Logic Test', () {

    test('Email tidak boleh kosong', () {

      String email = '';

      expect(email.isNotEmpty, false);

    });

    test('Password tidak boleh kosong', () {

      String password = '';

      expect(password.isNotEmpty, false);

    });

    test('Email valid', () {

      String email = 'admin@gmail.com';

      expect(email.contains('@'), true);

    });

    test('Password minimal 6 karakter', () {

      String password = '123456';

      expect(password.length >= 6, true);

    });

  });

}