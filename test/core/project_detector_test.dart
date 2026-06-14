import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('ProjectDetector', () {
    test('detects a valid Flutter project', () {
      final directory = Directory.systemTemp.createTempSync('fpt_project_');
      addTearDown(() => directory.deleteSync(recursive: true));

      File(p.join(directory.path, 'pubspec.yaml')).writeAsStringSync('''
name: sample_app
dependencies:
  flutter:
    sdk: flutter
''');

      final project = ProjectDetector(rootPath: directory.path).detect();

      expect(project.hasPubspec, isTrue);
      expect(project.isFlutterProject, isTrue);
      expect(project.rootPath, directory.path);
    });

    test('rejects a folder without pubspec.yaml', () {
      final directory = Directory.systemTemp.createTempSync('fpt_project_');
      addTearDown(() => directory.deleteSync(recursive: true));

      final project = ProjectDetector(rootPath: directory.path).detect();

      expect(project.hasPubspec, isFalse);
      expect(project.isFlutterProject, isFalse);
    });
  });
}
