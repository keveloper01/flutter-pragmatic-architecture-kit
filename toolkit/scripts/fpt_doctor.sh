#!/bin/sh
set -eu

if [ ! -f "pubspec.yaml" ]; then
  echo "pubspec.yaml not found. Run this script from a Flutter project root."
  exit 1
fi

if ! grep -q "sdk: flutter" pubspec.yaml; then
  echo "This does not look like a Flutter project."
  exit 1
fi

echo "Flutter project shape detected."
