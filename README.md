# Flutter Pragmatic Architecture Kit

Flutter Pragmatic Architecture Kit is a Dart CLI that installs a practical working structure for Flutter projects.

It is designed for teams that want a clear layered architecture, lightweight AI-agent guidance, starter specs, templates, scripts, and audit checks without adding runtime framework decisions to the app.

Target architecture:

```text
UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model
```

## What This Is

- A local developer tooling CLI named `fpt`.
- A starter architecture kit for Flutter projects.
- A set of project docs, specs, templates, scripts, wiki pages, and AI-agent instructions.
- A small audit tool for checking architecture guardrails.

## What This Is Not

- It is not a Flutter state management package.
- It is not a runtime dependency for your app.
- It is not a code generator.
- It is not a replacement for product-specific architecture decisions.

## Local installation

From this package directory:

```sh
dart pub get
dart pub global activate --source path .
```

If needed, add Dart global executables to your shell PATH:

```sh
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Then run:

```sh
fpt --help
```

During development you can also run:

```sh
dart run bin/fpt.dart --help
```

## Install From GitHub

After the repository is published:

```sh
dart pub global activate --source git https://github.com/keveloper01/flutter-pragmatic-architecture-kit
```

Then verify:

```sh
fpt --help
```

## Commands

```sh
fpt install
```

Installs the toolkit files into the current Flutter project. Existing files are not overwritten by default.

```sh
fpt install --force
```

Installs the toolkit and overwrites existing toolkit files.

```sh
fpt doctor
```

Checks that the current folder is a Flutter project and that the toolkit structure is installed.

```sh
fpt audit
```

Validates toolkit structure, checks for prohibited web references in toolkit files, and guards against direct data access from `lib/presentation`.

```sh
fpt feature --name "User Profile"
```

Creates a feature scaffold using a normalized snake_case name.

## Example

From a Flutter project root:

```sh
fpt install
fpt doctor
fpt audit
fpt feature --name "User Profile"
flutter analyze
```
