import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart' as og;
import 'package:path_provider_ffi/path_provider_ffi.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("original package", () {
    test(
      'getTemporaryDirectory',
      () => testAgainstOriginalPackage(
        og.getTemporaryDirectory,
        getTemporaryDirectory,
      ),
    );
    test(
      'getApplicationSupportDirectory',
      () => testAgainstOriginalPackage(
        og.getApplicationSupportDirectory,
        getApplicationSupportDirectory,
      ),
    );
    test(
      'getLibraryDirectory',
      () => testAgainstOriginalPackage(
        og.getLibraryDirectory,
        getLibraryDirectory,
      ),
    );
    test(
      'getApplicationDocumentsDirectory',
      () => testAgainstOriginalPackage(
        og.getApplicationDocumentsDirectory,
        getApplicationDocumentsDirectory,
      ),
    );
    test(
      'getApplicationCacheDirectory',
      () => testAgainstOriginalPackage(
        og.getApplicationCacheDirectory,
        getApplicationCacheDirectory,
      ),
    );
    test(
      'getExternalStorageDirectory',
      () => testAgainstOriginalPackage(
        og.getExternalStorageDirectory,
        getExternalStorageDirectory,
      ),
    );
    test(
      'getExternalCacheDirectories',
      () => testAgainstOriginalPackage(
        og.getExternalCacheDirectories,
        getExternalCacheDirectories,
      ),
    );
    test(
      'getDownloadsDirectory',
      () => testAgainstOriginalPackage(
        og.getDownloadsDirectory,
        getDownloadsDirectory,
      ),
    );
    test(
      'getExternalStoragePaths',
      () => testAgainstOriginalPackage(
        og.getExternalStorageDirectories,
        getExternalStorageDirectories,
      ),
    );
  });
}

Future testAgainstOriginalPackage(
  Future Function() getDirectory1,
  Function() getDirectory2,
) async {
  dynamic path1;
  try {
    path1 = await getDirectory1();
  } on og.MissingPlatformDirectoryException catch (_) {
    path1 = "MissingPlatformDirectoryException";
  } on UnsupportedError catch (_) {
    path1 = "UnsupportedError";
  }
  dynamic path2;
  try {
    path2 = getDirectory2();
  } on MissingPlatformDirectoryException catch (_) {
    path2 = "MissingPlatformDirectoryException";
  } on UnsupportedError catch (_) {
    path2 = "UnsupportedError";
  }
  if (path1 is Directory && path2 is Directory) {
    expect(path1.path, equals(path2.path));
  } else if (path1 is List<Directory> && path2 is List<Directory>) {
    expect(listEquals(path1, path2), isTrue);
  } else {
    expect(path1, equals(path2));
  }
}
