import 'dart:io';

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
    test(
      'getExternalStoragePaths#Music',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(type: og.StorageDirectory.music),
        () => getExternalStorageDirectories(type: StorageDirectory.music),
      ),
    );
    test(
      'getExternalStoragePaths#Podcasts',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(
          type: og.StorageDirectory.podcasts,
        ),
        () => getExternalStorageDirectories(type: StorageDirectory.podcasts),
      ),
    );
    test(
      'getExternalStoragePaths#Ringtones',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(
          type: og.StorageDirectory.ringtones,
        ),
        () => getExternalStorageDirectories(type: StorageDirectory.ringtones),
      ),
    );
    test(
      'getExternalStoragePaths#Alarms',
      () => testAgainstOriginalPackage(
        () =>
            og.getExternalStorageDirectories(type: og.StorageDirectory.alarms),
        () => getExternalStorageDirectories(type: StorageDirectory.alarms),
      ),
    );
    test(
      'getExternalStoragePaths#Notifications',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(
          type: og.StorageDirectory.notifications,
        ),
        () =>
            getExternalStorageDirectories(type: StorageDirectory.notifications),
      ),
    );
    test(
      'getExternalStoragePaths#Pictures',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(
          type: og.StorageDirectory.pictures,
        ),
        () => getExternalStorageDirectories(type: StorageDirectory.pictures),
      ),
    );
    test(
      'getExternalStoragePaths#Movies',
      () => testAgainstOriginalPackage(
        () =>
            og.getExternalStorageDirectories(type: og.StorageDirectory.movies),
        () => getExternalStorageDirectories(type: StorageDirectory.movies),
      ),
    );
    test(
      'getExternalStoragePaths#Downloads',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(
          type: og.StorageDirectory.downloads,
        ),
        () => getExternalStorageDirectories(type: StorageDirectory.downloads),
      ),
    );
    test(
      'getExternalStoragePaths#Documents',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(
          type: og.StorageDirectory.documents,
        ),
        () => getExternalStorageDirectories(type: StorageDirectory.documents),
      ),
    );
    test(
      'getExternalStoragePaths#DCIM',
      () => testAgainstOriginalPackage(
        () => og.getExternalStorageDirectories(type: og.StorageDirectory.dcim),
        () => getExternalStorageDirectories(type: StorageDirectory.dcim),
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
    expect(path1.existsSync(), equals(path2.existsSync()));
  } else if (path1 is List<Directory> && path2 is List<Directory>) {
    for (var (p1, p2) in zip(path1, path2)) {
      expect(p1.path, equals(p2.path));
      expect(p1.existsSync(), equals(p2.existsSync()));
    }
  } else {
    expect(path1, equals(path2));
  }
}

List<(T, T)> zip<T>(List<T> a, List<T> b) {
  assert(a.length == b.length);
  return List.generate(a.length, (i) => (a[i], b[i]));
}
