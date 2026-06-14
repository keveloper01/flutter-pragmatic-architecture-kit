import 'dart:io';

import 'package:path/path.dart' as p;

class ProjectDetector {
  const ProjectDetector({String? rootPath}) : _rootPath = rootPath;

  final String? _rootPath;

  ProjectInfo detect() {
    final rootPath = _rootPath ?? Directory.current.path;
    final pubspecFile = File(p.join(rootPath, 'pubspec.yaml'));

    if (!pubspecFile.existsSync()) {
      return ProjectInfo(
        rootPath: rootPath,
        hasPubspec: false,
        isFlutterProject: false,
      );
    }

    final pubspecContent = pubspecFile.readAsStringSync();

    return ProjectInfo(
      rootPath: rootPath,
      hasPubspec: true,
      isFlutterProject: _containsFlutterSdkDependency(pubspecContent),
    );
  }

  bool _containsFlutterSdkDependency(String pubspecContent) {
    final lines = pubspecContent.split('\n');

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trimRight();
      if (!RegExp(r'^\s*flutter\s*:\s*$').hasMatch(line)) {
        continue;
      }

      final flutterIndent = line.length - line.trimLeft().length;
      for (var nextIndex = index + 1; nextIndex < lines.length; nextIndex++) {
        final nextLine = lines[nextIndex];
        if (nextLine.trim().isEmpty || nextLine.trimLeft().startsWith('#')) {
          continue;
        }

        final nextIndent = nextLine.length - nextLine.trimLeft().length;
        if (nextIndent <= flutterIndent) {
          break;
        }

        if (RegExp(r'^\s*sdk\s*:\s*flutter\s*$').hasMatch(nextLine)) {
          return true;
        }
      }
    }

    return false;
  }
}

class ProjectInfo {
  const ProjectInfo({
    required this.rootPath,
    required this.hasPubspec,
    required this.isFlutterProject,
  });

  final String rootPath;
  final bool hasPubspec;
  final bool isFlutterProject;
}
