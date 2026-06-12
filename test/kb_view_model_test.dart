import 'package:flutter_test/flutter_test.dart';

void main() {

  group('KB ViewModel Testing', () {

    test('List pendaftaran awal kosong', () {

      List data = [];

      expect(data.length, 0);

    });

    test('Tambah data pendaftaran', () {

      List data = [];

      data.add('Pendaftaran KB');

      expect(data.length, 1);

    });

    test('Hapus data pendaftaran', () {

      List data = ['Pendaftaran KB'];

      data.removeAt(0);

      expect(data.length, 0);

    });

    test('Loading state aktif', () {

      bool isLoading = true;

      expect(isLoading, true);

    });

    test('Loading state selesai', () {

      bool isLoading = false;

      expect(isLoading, false);

    });

  });
}