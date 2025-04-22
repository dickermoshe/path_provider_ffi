// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// These tests have been copied from the main path_provider package's example app

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider_ffi/path_provider_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getTemporaryDirectory', (WidgetTester tester) async {
    final Directory result = getTemporaryDirectory();
    _verifySampleFile(result, 'temporaryDirectory');
  });

  testWidgets('getApplicationDocumentsDirectory', (WidgetTester tester) async {
    final Directory result = getApplicationDocumentsDirectory();
    if (Platform.isMacOS) {
      // _verifySampleFile causes hangs in driver when sandboxing is disabled
      // because the path changes from an app specific directory to
      // ~/Documents, which requires additional permissions to access on macOS.
      // Instead, validate that a non-empty path was returned.
      expect(result.path, isNotEmpty);
    } else {
      _verifySampleFile(result, 'applicationDocuments');
    }
  });

  testWidgets('getApplicationSupportDirectory', (WidgetTester tester) async {
    final Directory result = getApplicationSupportDirectory();
    _verifySampleFile(result, 'applicationSupport');
  });

  testWidgets('getApplicationCacheDirectory', (WidgetTester tester) async {
    final Directory result = getApplicationCacheDirectory();
    _verifySampleFile(result, 'applicationCache');
  });

  testWidgets('getLibraryDirectory', (WidgetTester tester) async {
    if (Platform.isIOS) {
      final Directory result = getLibraryDirectory();
      _verifySampleFile(result, 'library');
    } else if (Platform.isAndroid) {
      expect(getLibraryDirectory, throwsA(isInstanceOf<UnsupportedError>()));
    }
  });

  testWidgets('getExternalStorageDirectory', (WidgetTester tester) async {
    if (Platform.isIOS) {
      expect(
        getExternalStorageDirectory,
        throwsA(isInstanceOf<UnsupportedError>()),
      );
    } else if (Platform.isAndroid) {
      final Directory? result = getExternalStorageDirectory();
      _verifySampleFile(result, 'externalStorage');
    }
  });

  testWidgets('getExternalCacheDirectories', (WidgetTester tester) async {
    if (Platform.isIOS) {
      expect(
        getExternalCacheDirectories,
        throwsA(isInstanceOf<UnsupportedError>()),
      );
    } else if (Platform.isAndroid) {
      final List<Directory>? directories = getExternalCacheDirectories();
      expect(directories, isNotNull);
      for (final Directory result in directories!) {
        _verifySampleFile(result, 'externalCache');
      }
    }
  });

  final List<StorageDirectory?> allDirs = <StorageDirectory?>[
    null,
    StorageDirectory.music,
    StorageDirectory.podcasts,
    StorageDirectory.ringtones,
    StorageDirectory.alarms,
    StorageDirectory.notifications,
    StorageDirectory.pictures,
    StorageDirectory.movies,
  ];

  for (final StorageDirectory? type in allDirs) {
    testWidgets('getExternalStorageDirectories (type: $type)', (
      WidgetTester tester,
    ) async {
      if (Platform.isIOS) {
        expect(
          getExternalStorageDirectories,
          throwsA(isInstanceOf<UnsupportedError>()),
        );
      } else if (Platform.isAndroid) {
        final List<Directory>? directories = getExternalStorageDirectories(
          type: type,
        );
        expect(directories, isNotNull);
        for (final Directory result in directories!) {
          _verifySampleFile(result, '$type');
        }
      }
    });
  }

  testWidgets('getDownloadsDirectory', (WidgetTester tester) async {
    final Directory? result = getDownloadsDirectory();
    // On recent versions of macOS, actually using the downloads directory
    // requires a user prompt (so will fail on CI), and on some platforms the
    // directory may not exist. Instead of verifying that it exists, just
    // check that it returned a path.
    expect(result?.path, isNotEmpty);
  });
}

/// Verify a file called [name] in [directory] by recreating it with test
/// contents when necessary.
void _verifySampleFile(Directory? directory, String name) {
  expect(directory, isNotNull);
  if (directory == null) {
    return;
  }
  final File file = File('${directory.path}/$name');

  if (file.existsSync()) {
    file.deleteSync();
    expect(file.existsSync(), isFalse);
  }

  file.writeAsStringSync('Hello world!');
  expect(file.readAsStringSync(), 'Hello world!');
  // This check intentionally avoids using Directory.listSync on Android due to
  // https://github.com/dart-lang/sdk/issues/54287.
  if (Platform.isAndroid) {
    expect(
      Process.runSync('ls', <String>[directory.path]).stdout,
      contains(name),
    );
  } else {
    expect(directory.listSync(), isNotEmpty);
  }
  file.deleteSync();
}
