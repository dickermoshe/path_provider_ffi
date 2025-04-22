#!/bin/bash
xvfb-run flutter test ./integration_test/original_package_test.dar;
xvfb-run flutter test ./integration_test/path_provider_android_test.dart;
