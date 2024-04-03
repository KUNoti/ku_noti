# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

name: Dart

on:
push:
branches: [ "main" ]
pull_request:
branches: [ "main" ]

jobs:
build:
runs-on: macos-latest
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
with:
channel: 'stable'
- run: flutter pub get
- run: flutter build ios --release --no-codesign


