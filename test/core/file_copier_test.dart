import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/core/file_copier.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('FileCopier', () {
    test('copies directories recursively', () {
      final root = Directory.systemTemp.createTempSync('fpt_copier_');
      addTearDown(() => root.deleteSync(recursive: true));

      final source = Directory(p.join(root.path, 'source'));
      final target = Directory(p.join(root.path, 'target'));
      Directory(p.join(source.path, 'docs', 'nested'))
          .createSync(recursive: true);
      File(p.join(source.path, 'docs', 'nested', 'readme.md'))
          .writeAsStringSync('hello');

      final result = const FileCopier().copyDirectory(
        sourcePath: source.path,
        targetPath: target.path,
      );

      expect(
        File(p.join(target.path, 'docs', 'nested', 'readme.md'))
            .readAsStringSync(),
        'hello',
      );
      expect(result.copiedFiles, 1);
      expect(result.skippedFiles, 0);
    });

    test('does not overwrite files when overwrite is false', () {
      final root = Directory.systemTemp.createTempSync('fpt_copier_');
      addTearDown(() => root.deleteSync(recursive: true));

      final source = Directory(p.join(root.path, 'source'))..createSync();
      final target = Directory(p.join(root.path, 'target'))..createSync();
      File(p.join(source.path, 'config.md')).writeAsStringSync('source');
      File(p.join(target.path, 'config.md')).writeAsStringSync('target');

      final result = const FileCopier().copyDirectory(
        sourcePath: source.path,
        targetPath: target.path,
        overwrite: false,
      );

      expect(
          File(p.join(target.path, 'config.md')).readAsStringSync(), 'target');
      expect(result.copiedFiles, 0);
      expect(result.skippedFiles, 1);
    });
  });
}
