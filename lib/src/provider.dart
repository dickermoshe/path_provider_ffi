// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:path_provider_ffi/src/platforms/foundation/path_provider_foundation.dart';
import 'package:path_provider_ffi/src/platforms/android/path_provider_android.dart';

import 'package:path_provider_ffi/src/platforms/windows/path_provider_windows.dart';

/// The interface that implementations of path_provider must implement.
///
/// Platform implementations should extend this class rather than implement it as `PathProvider`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [PathProvider] methods.
abstract class PathProvider {
  /// Constructs a PathProviderPlatform.
  PathProvider();

  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files.
  String? getTemporaryPath();

  /// Path to a directory where the application may place application support
  /// files.
  String? getApplicationSupportPath();

  /// Path to the directory where application can store files that are persistent,
  /// backed up, and not visible to the user, such as sqlite.db.
  String? getLibraryPath();

  /// Path to a directory where the application may place data that is
  /// user-generated, or that cannot otherwise be recreated by your application.
  String? getApplicationDocumentsPath();

  /// Path to a directory where application specific cache data can be stored.
  String? getApplicationCachePath();

  /// Path to a directory where the application may access top level storage.
  /// The current operating system should be determined before issuing this
  /// function call, as this functionality is only available on Android.
  String? getExternalStoragePath();

  /// Paths to directories where application specific external cache data can be
  /// stored. These paths typically reside on external storage like separate
  /// partitions or SD cards. Phones may have multiple storage directories
  /// available.
  List<String>? getExternalCachePaths();

  /// Paths to directories where application specific data can be stored.
  /// These paths typically reside on external storage like separate partitions
  /// or SD cards. Phones may have multiple storage directories available.
  List<String>? getExternalStoragePaths({
    /// Optional parameter. See [StorageDirectory] for more informations on
    /// how this type translates to Android storage directories.
    StorageDirectory? type,
  });

  /// Path to the directory where downloaded files can be stored.
  /// This is typically only relevant on desktop operating systems.
  String? getDownloadsPath();

  static PathProvider instance =
      Platform.isIOS || Platform.isMacOS
          ? PathProviderFoundation()
          : Platform.isWindows
          ? PathProviderWindows()
          : Platform.isAndroid
          ? PathProviderAndroid()
          : throw UnsupportedError('Unsupported platform');
}

/// Corresponds to constants defined in Androids `android.os.Environment` class.
///
/// https://developer.android.com/reference/android/os/Environment.html#fields_1
enum StorageDirectory {
  /// Contains audio files that should be treated as music.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_MUSIC.
  music,

  /// Contains audio files that should be treated as podcasts.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_PODCASTS.
  podcasts,

  /// Contains audio files that should be treated as ringtones.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_RINGTONES.
  ringtones,

  /// Contains audio files that should be treated as alarm sounds.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_ALARMS.
  alarms,

  /// Contains audio files that should be treated as notification sounds.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_NOTIFICATIONS.
  notifications,

  /// Contains images. See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_PICTURES.
  pictures,

  /// Contains movies. See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_MOVIES.
  movies,

  /// Contains files of any type that have been downloaded by the user.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_DOWNLOADS.
  downloads,

  /// Used to hold both pictures and videos when the device filesystem is
  /// treated like a camera's.
  ///
  /// See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_DCIM.
  dcim,

  /// Holds user-created documents. See https://developer.android.com/reference/android/os/Environment.html#DIRECTORY_DOCUMENTS.
  documents,
}
