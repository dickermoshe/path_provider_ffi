// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jni/jni.dart';
import 'package:path_provider_ffi/src/platforms/android/bindings.dart';
import 'package:path_provider_ffi/src/provider.dart';

/// The android implementation of [PathProvider]
///
/// This class implements the `package:path_provider` functionality for Android.
class PathProviderAndroid extends PathProvider {
  /// The context used to access the Android environment.
  ///
  /// The returned object must be released after use, by calling the [release] method.
  Context get _context =>
      Context.fromReference(Jni.getCachedApplicationContext());

  PathProviderAndroid();
  @override
  String? getApplicationCachePath() {
    return _context.use(
      (context) => context
          .getCacheDir()
          ?.use((dir) => dir.getPath())
          ?.toDartString(releaseOriginal: true),
    );
  }

  @override
  String? getApplicationDocumentsPath() {
    return _context.use(
      (context) => PathUtils.getDataDirectory(
        context,
      ).toDartString(releaseOriginal: true),
    );
  }

  @override
  String? getApplicationSupportPath() {
    return _context.use(
      (context) =>
          PathUtils.getFilesDir(context).toDartString(releaseOriginal: true),
    );
  }

  @override
  String? getDownloadsPath() {
    return getExternalStoragePaths(
      type: StorageDirectory.downloads,
    )?.firstOrNull;
  }

  @override
  List<String>? getExternalCachePaths() {
    return _context.use((context) => context.getExternalCacheDirs())?.use((
      paths,
    ) {
      return paths
          .map(
            (path) =>
                path?.getAbsolutePath()?.toDartString(releaseOriginal: true),
          )
          .nonNulls
          .toList();
    });
  }

  @override
  String? getExternalStoragePath() {
    return _context.use(
      (context) => context
          .getExternalFilesDir(null)
          ?.use((dir) => dir.getPath()?.toDartString(releaseOriginal: true)),
    );
  }

  @override
  List<String>? getExternalStoragePaths({StorageDirectory? type}) {
    final storageDirString = _getStorageDirectoryString(type)?.toJString();
    try {
      return _context
          .use((context) => context.getExternalFilesDirs(storageDirString))
          ?.use(
            (paths) =>
                paths
                    .map(
                      (path) => path?.use(
                        (file) => file.getAbsolutePath()?.toDartString(
                          releaseOriginal: true,
                        ),
                      ),
                    )
                    .nonNulls
                    .toList(),
          );
    } finally {
      storageDirString?.release();
    }
  }

  @override
  String? getLibraryPath() {
    throw UnimplementedError('getLibraryPath is not implemented on Android');
  }

  @override
  String? getTemporaryPath() {
    return _context.use(
      (context) => context.getCacheDir()?.use(
        (dir) => dir.getPath()?.toDartString(releaseOriginal: true),
      ),
    );
  }

  String? _getStorageDirectoryString(StorageDirectory? directory) {
    switch (directory) {
      case null:
        return null;
      case StorageDirectory.music:
        return "music";
      case StorageDirectory.podcasts:
        return "podcasts";
      case StorageDirectory.ringtones:
        return "ringtones";
      case StorageDirectory.alarms:
        return "alarms";
      case StorageDirectory.notifications:
        return "notifications";
      case StorageDirectory.pictures:
        return "pictures";
      case StorageDirectory.movies:
        return "movies";
      case StorageDirectory.downloads:
        return "downloads";
      case StorageDirectory.dcim:
        return "dcim";
      case StorageDirectory.documents:
        return "documents";
    }
  }
}
