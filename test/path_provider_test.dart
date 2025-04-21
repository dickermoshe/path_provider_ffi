// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Directory;

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_ffi/path_provider_ffi.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const String kTemporaryPath = 'temporaryPath';
const String kApplicationSupportPath = 'applicationSupportPath';
const String kDownloadsPath = 'downloadsPath';
const String kLibraryPath = 'libraryPath';
const String kApplicationDocumentsPath = 'applicationDocumentsPath';
const String kExternalCachePath = 'externalCachePath';
const String kExternalStoragePath = 'externalStoragePath';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PathProvider full implementation', () {
    setUp(() async {
      PathProvider.instance = FakePathProviderPlatform();
    });

    test('getTemporaryDirectory', () async {
      final Directory result = getTemporaryDirectory();
      expect(result.path, kTemporaryPath);
    });

    test('getApplicationSupportDirectory', () async {
      final Directory result = getApplicationSupportDirectory();
      expect(result.path, kApplicationSupportPath);
    });

    test('getLibraryDirectory', () async {
      final Directory result = getLibraryDirectory();
      expect(result.path, kLibraryPath);
    });

    test('getApplicationDocumentsDirectory', () async {
      final Directory result = getApplicationDocumentsDirectory();
      expect(result.path, kApplicationDocumentsPath);
    });

    test('getExternalStorageDirectory', () async {
      final Directory? result = getExternalStorageDirectory();
      expect(result?.path, kExternalStoragePath);
    });

    test('getExternalCacheDirectories', () async {
      final List<Directory>? result = getExternalCacheDirectories();
      expect(result?.length, 1);
      expect(result?.first.path, kExternalCachePath);
    });

    test('getExternalStorageDirectories', () async {
      final List<Directory>? result = getExternalStorageDirectories();
      expect(result?.length, 1);
      expect(result?.first.path, kExternalStoragePath);
    });

    test('getDownloadsDirectory', () async {
      final Directory? result = getDownloadsDirectory();
      expect(result?.path, kDownloadsPath);
    });
  });

  group('PathProvider null implementation', () {
    setUp(() async {
      PathProvider.instance = AllNullFakePathProviderPlatform();
    });

    test('getTemporaryDirectory throws on null', () async {
      expect(
        getTemporaryDirectory,
        throwsA(isA<MissingPlatformDirectoryException>()),
      );
    });

    test('getApplicationSupportDirectory throws on null', () async {
      expect(
        getApplicationSupportDirectory,
        throwsA(isA<MissingPlatformDirectoryException>()),
      );
    });

    test('getLibraryDirectory throws on null', () async {
      expect(
        getLibraryDirectory,
        throwsA(isA<MissingPlatformDirectoryException>()),
      );
    });

    test('getApplicationDocumentsDirectory throws on null', () async {
      expect(
        getApplicationDocumentsDirectory,
        throwsA(isA<MissingPlatformDirectoryException>()),
      );
    });

    test('getExternalStorageDirectory passes null through', () async {
      final Directory? result = getExternalStorageDirectory();
      expect(result, isNull);
    });

    test('getExternalCacheDirectories passes null through', () async {
      final List<Directory>? result = getExternalCacheDirectories();
      expect(result, isNull);
    });

    test('getExternalStorageDirectories passes null through', () async {
      final List<Directory>? result = getExternalStorageDirectories();
      expect(result, isNull);
    });

    test('getDownloadsDirectory passses null through', () async {
      final Directory? result = getDownloadsDirectory();
      expect(result, isNull);
    });
  });
}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProvider {
  @override
  String? getTemporaryPath() {
    return kTemporaryPath;
  }

  @override
  String? getApplicationSupportPath() {
    return kApplicationSupportPath;
  }

  @override
  String? getLibraryPath() {
    return kLibraryPath;
  }

  @override
  String? getApplicationDocumentsPath() {
    return kApplicationDocumentsPath;
  }

  @override
  String? getExternalStoragePath() {
    return kExternalStoragePath;
  }

  @override
  List<String>? getExternalCachePaths() {
    return <String>[kExternalCachePath];
  }

  @override
  List<String>? getExternalStoragePaths({StorageDirectory? type}) {
    return <String>[kExternalStoragePath];
  }

  @override
  String? getDownloadsPath() {
    return kDownloadsPath;
  }
}

class AllNullFakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProvider {
  @override
  String? getTemporaryPath() {
    return null;
  }

  @override
  String? getApplicationSupportPath() {
    return null;
  }

  @override
  String? getLibraryPath() {
    return null;
  }

  @override
  String? getApplicationDocumentsPath() {
    return null;
  }

  @override
  String? getExternalStoragePath() {
    return null;
  }

  @override
  List<String>? getExternalCachePaths() {
    return null;
  }

  @override
  List<String>? getExternalStoragePaths({StorageDirectory? type}) {
    return null;
  }

  @override
  String? getDownloadsPath() {
    return null;
  }
}
