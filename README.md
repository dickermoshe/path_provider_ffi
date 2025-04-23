# path_provider_ffi
<?code-excerpt path-base="example/lib"?>

[![pub package](https://img.shields.io/pub/v/path_provider_ffi.svg)](https://pub.dev/packages/path_provider_ffi)

A port the the `path_provider` Flutter plugin for finding commonly used locations on the filesystem.
Supports Android, iOS, Linux, macOS and Windows. This port uses FFI to access the native APIs instead of the platform channels used by the original plugin. 


Not all methods are supported on all platforms.

|             | Android | iOS   | Linux | macOS  | Windows     |
| ----------- | ------- | ----- | ----- | ------ | ----------- |
| **Support** | SDK 21+ | 12.0+ | Any   | 10.14+ | Windows 10+ |

## Disclaimer

This package depends on many experimental packages provided by the [Dart Labs Team](https://pub.dev/publishers/labs.dart.dev/packages). The `objective_c` package is used to interact with Objective-C APIs on iOS and macOS. `ffigen` and `jnigen` are also experimental packages, however these are only used to generate the bindings for the native libraries. 

This package contains all the tests from the original `path_provider` plugin and is also tested against the original plugin to ensure that the results are the same.

## Example
<?code-excerpt "readme_excerpts.dart (Example)"?>
```dart
final Directory tempDir = getTemporaryDirectory();

final Directory appDocumentsDir = getApplicationDocumentsDirectory();

final Directory? downloadsDir = getDownloadsDirectory();
```

## Supported platforms and paths

Directories support by platform:

| Directory                    | Android |  iOS  | Linux | macOS | Windows |
| :--------------------------- | :-----: | :---: | :---: | :---: | :-----: |
| Temporary                    |    ✔️    |   ✔️   |   ✔️   |   ✔️   |    ✔️    |
| Application Support          |    ✔️    |   ✔️   |   ✔️   |   ✔️   |    ✔️    |
| Application Library          |    ❌️    |   ✔️   |   ❌️   |   ✔️   |    ❌️    |
| Application Documents        |    ✔️    |   ✔️   |   ✔️   |   ✔️   |    ✔️    |
| Application Cache            |    ✔️    |   ✔️   |   ✔️   |   ✔️   |    ✔️    |
| External Storage             |    ✔️    |   ❌   |   ❌   |   ❌️   |    ❌️    |
| External Cache Directories   |    ✔️    |   ❌   |   ❌   |   ❌️   |    ❌️    |
| External Storage Directories |    ✔️    |   ❌   |   ❌   |   ❌️   |    ❌️    |
| Downloads                    |    ✔️    |   ✔️   |   ✔️   |   ✔️   |    ✔️    |

## Testing

`path_provider_ffi` uses the same tests as the original `path_provider` plugin as well as comparison tests to ensure that the results are the same. The tests are run on all platforms using the `flutter_test` package.

Tests are ran on [RunsOn](https://runs-on.com/), an awesome open source github runner alternative.