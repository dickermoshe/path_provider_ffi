// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';

import 'package:objective_c/objective_c.dart';
import 'package:path_provider_ffi/src/platforms/foundation/bindings.dart';
import 'package:path_provider_ffi/src/provider.dart';

/// The Foundation implementation of [PathProvider]
///
/// This class implements the `package:path_provider` functionality for iOS and macOS.
class PathProviderFoundation extends PathProvider {
  late final NSFileManagerLib fm = NSFileManagerLib(DynamicLibrary.process());
  PathProviderFoundation();

  NSString? _getDirectoryPath(
    NSSearchPathDirectory type, {
    bool isTemp = false,
  }) {
    var path = _getDirectory(type);
    if (Platform.isMacOS && !isTemp) {
      // In a non-sandboxed app, these are shared directories where applications are
      // expected to use its bundle ID as a subdirectory. (For non-sandboxed apps,
      // adding the extra path is harmless).
      // This is not done for iOS, for compatibility with older versions of the
      // plugin.
      if (type == NSSearchPathDirectory.NSApplicationSupportDirectory ||
          type == NSSearchPathDirectory.NSCachesDirectory) {
        if (path != null) {
          final basePath = path;
          final basePathURL = NSURL.fileURLWithPath_(basePath);

          path =
              basePathURL.URLByAppendingPathComponent_(
                NSBundle.getMainBundle().bundleIdentifier!,
              )!.path;
        }
      }
    }

    return path;
  }

  /// Returns the user-domain directory of the given type.
  NSString? _getDirectory(NSSearchPathDirectory directory) {
    final paths = fm.NSSearchPathForDirectoriesInDomains(
      directory,
      NSSearchPathDomainMask.NSUserDomainMask,
      true,
    );
    if (paths.count == 0) {
      return null;
    }
    final path = paths.objectAtIndex_(0);
    if (path.ref.pointer == nullptr) {
      return null;
    }
    return NSString.castFrom(path);
  }

  // // Returns the path for the container of the specified app group.
  // String? getContainerPath(String appGroupIdentifier) {
  //   if (!Platform.isIOS) {
  //     throw UnsupportedError(
  //       'getContainerPath is not supported on this platform',
  //     );
  //   }
  //   return NSFileManager.getDefaultManager()
  //       .containerURLForSecurityApplicationGroupIdentifier_(
  //         appGroupIdentifier.toNSString(),
  //       )
  //       ?.path
  //       ?.toDartString();
  // }

  @override
  String? getApplicationCachePath() {
    final path =
        _getDirectoryPath(
          NSSearchPathDirectory.NSCachesDirectory,
        )?.toDartString();
    if (path != null) {
      ensureExists(path);
    }
    return path;
  }

  @override
  String? getApplicationDocumentsPath() {
    return _getDirectoryPath(
      NSSearchPathDirectory.NSDocumentDirectory,
    )?.toDartString();
  }

  @override
  String? getApplicationSupportPath() {
    final path =
        _getDirectoryPath(
          NSSearchPathDirectory.NSApplicationSupportDirectory,
        )?.toDartString();
    if (path != null) {
      ensureExists(path);
    }
    return path;
  }

  @override
  String? getDownloadsPath() {
    return _getDirectoryPath(
      NSSearchPathDirectory.NSDownloadsDirectory,
    )?.toDartString();
  }

  @override
  List<String>? getExternalCachePaths() {
    throw UnsupportedError(
      'getExternalCachePaths is not supported on this platform',
    );
  }

  @override
  String? getExternalStoragePath() {
    throw UnsupportedError(
      'getExternalStoragePath is not supported on this platform',
    );
  }

  @override
  List<String>? getExternalStoragePaths({StorageDirectory? type}) {
    throw UnsupportedError(
      'getExternalStoragePaths is not supported on this platform',
    );
  }

  @override
  String? getLibraryPath() {
    return _getDirectoryPath(
      NSSearchPathDirectory.NSLibraryDirectory,
    )?.toDartString();
  }

  @override
  String? getTemporaryPath() {
    return _getDirectoryPath(
      NSSearchPathDirectory.NSCachesDirectory,
      isTemp: true,
    )?.toDartString();
  }

  void ensureExists(String path) {
    Directory(path).createSync(recursive: true);
  }
}
