// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_ffi/src/provider.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

import 'get_application_id.dart';

/// The linux implementation of [PathProvider]
///
/// This class implements the `package:path_provider` functionality for Linux.
class PathProviderLinux extends PathProvider {
  /// Constructs an instance of [PathProviderLinux]
  PathProviderLinux() : _environment = Platform.environment;

  /// Constructs an instance of [PathProviderLinux] with the given [environment]
  @visibleForTesting
  PathProviderLinux.private({
    Map<String, String> environment = const <String, String>{},
    String? executableName,
    String? applicationId,
  }) : _environment = environment,
       _executableName = executableName,
       _applicationId = applicationId;

  final Map<String, String> _environment;
  String? _executableName;
  String? _applicationId;

  @override
  String? getTemporaryPath() {
    final String environmentTmpDir = _environment['TMPDIR'] ?? '';
    return environmentTmpDir.isEmpty ? '/tmp' : environmentTmpDir;
  }

  @override
  String? getApplicationSupportPath() {
    final Directory directory = Directory(
      path.join(xdg.dataHome.path, _getId()),
    );
    if (directory.existsSync()) {
      return directory.path;
    }

    // This plugin originally used the executable name as a directory.
    // Use that if it exists for backwards compatibility.
    final Directory legacyDirectory = Directory(
      path.join(xdg.dataHome.path, _getExecutableName()),
    );
    if (legacyDirectory.existsSync()) {
      return legacyDirectory.path;
    }

    // Create the directory, because mobile implementations assume the directory exists.
    directory.createSync(recursive: true);
    return directory.path;
  }

  @override
  String? getApplicationDocumentsPath() {
    return xdg.getUserDirectory('DOCUMENTS')?.path;
  }

  @override
  String? getApplicationCachePath() {
    final Directory directory = Directory(
      path.join(xdg.cacheHome.path, _getId()),
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory.path;
  }

  @override
  String? getDownloadsPath() {
    return xdg.getUserDirectory('DOWNLOAD')?.path;
  }

  // Gets the name of this executable.
  String _getExecutableName() {
    _executableName ??= path.basenameWithoutExtension(
      File('/proc/self/exe').resolveSymbolicLinksSync(),
    );
    return _executableName!;
  }

  // Gets the unique ID for this application.
  String _getId() {
    _applicationId ??= getApplicationId();
    // If no application ID then fall back to using the executable name.
    return _applicationId ?? _getExecutableName();
  }

  @override
  List<String>? getExternalCachePaths() {
    throw UnimplementedError(
      'getExternalCachePaths() has not been implemented.',
    );
  }

  @override
  String? getExternalStoragePath() {
    throw UnimplementedError(
      'getExternalStoragePath() has not been implemented.',
    );
  }

  @override
  List<String>? getExternalStoragePaths({StorageDirectory? type}) {
    throw UnimplementedError(
      'getExternalStoragePaths() has not been implemented.',
    );
  }

  @override
  String? getLibraryPath() {
    throw UnimplementedError('getLibraryPath() has not been implemented.');
  }
}
