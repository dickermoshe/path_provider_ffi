@TestOn('ios || mac-os')
library;
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider_ffi/path_provider_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getTemporaryDirectory', (WidgetTester tester) async {
    final PathProvider provider = PathProvider.instance;
    final String? result = provider.getTemporaryPath();
    _verifySampleFile(result, 'temporaryDirectory');
  });

  testWidgets('getApplicationDocumentsDirectory', (WidgetTester tester) async {
    final PathProvider provider = PathProvider.instance;
    final String? result = provider.getApplicationDocumentsPath();
    if (Platform.isMacOS) {
      // _verifySampleFile causes hangs in driver when sandboxing is disabled
      // because the path changes from an app specific directory to
      // ~/Documents, which requires additional permissions to access on macOS.
      // Instead, validate that a non-empty path was returned.
      expect(result, isNotEmpty);
    } else {
      _verifySampleFile(result, 'applicationDocuments');
    }
  });

  testWidgets('getApplicationSupportDirectory', (WidgetTester tester) async {
    final PathProvider provider = PathProvider.instance;
    final String? result = provider.getApplicationSupportPath();
    _verifySampleFile(result, 'applicationSupport');
  });

  testWidgets('getApplicationCacheDirectory', (WidgetTester tester) async {
    final PathProvider provider = PathProvider.instance;
    final String? result = provider.getApplicationCachePath();
    _verifySampleFile(result, 'applicationCache');
  });

  testWidgets('getLibraryDirectory', (WidgetTester tester) async {
    final PathProvider provider = PathProvider.instance;
    final String? result = provider.getLibraryPath();
    _verifySampleFile(result, 'library');
  });

  testWidgets('getDownloadsDirectory', (WidgetTester tester) async {
    final PathProvider provider = PathProvider.instance;
    final String? result = provider.getDownloadsPath();
    // _verifySampleFile causes hangs in driver for some reason, so just
    // validate that a non-empty path was returned.
    expect(result, isNotEmpty);
  });

  // testWidgets('getContainerDirectory', (WidgetTester tester) async {
  //   if (Platform.isIOS) {
  //     final PathProviderFoundation provider = PathProviderFoundation();

  //     final String? result = provider.getContainerPath(
  //       'group.flutter.appGroupTest',
  //     );
  //     _verifySampleFile(result, 'appGroup');
  //   }
  // });
}

/// Verify a file called [name] in [directoryPath] by recreating it with test
/// contents when necessary.
///
/// If [createDirectory] is true, the directory will be created if missing.
void _verifySampleFile(String? directoryPath, String name) {
  expect(directoryPath, isNotNull);
  if (directoryPath == null) {
    return;
  }
  final Directory directory = Directory(directoryPath);
  final File file = File('${directory.path}${Platform.pathSeparator}$name');

  if (file.existsSync()) {
    file.deleteSync();
    expect(file.existsSync(), isFalse);
  }

  file.writeAsStringSync('Hello world!');
  expect(file.readAsStringSync(), 'Hello world!');
  expect(directory.listSync(), isNotEmpty);
  file.deleteSync();
}
