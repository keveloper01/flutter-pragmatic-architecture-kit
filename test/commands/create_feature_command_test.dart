import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/create_feature_command.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('feature command', () {
    test('normalizes feature names to snake_case', () async {
      final directory = Directory.systemTemp.createTempSync('fpt_feature_');
      addTearDown(() => directory.deleteSync(recursive: true));

      File(p.join(directory.path, 'pubspec.yaml')).writeAsStringSync('''
name: sample_app
dependencies:
  flutter:
    sdk: flutter
''');

      final runner = CommandRunner<void>('fpt', 'test runner')
        ..addCommand(
          CreateFeatureCommand(
            logger: const Logger(),
            projectDetector: ProjectDetector(rootPath: directory.path),
          ),
        );

      await runner.run(['feature', '--name', 'User Profile']);

      expect(
        Directory(p.join(
                directory.path, 'lib', 'domain', 'user_profile', 'models'))
            .existsSync(),
        isTrue,
      );
      expect(
        Directory(
          p.join(
            directory.path,
            'lib',
            'presentation',
            'containers',
            'user_profile',
            'bloc',
          ),
        ).existsSync(),
        isTrue,
      );
      expect(
        File(p.join(directory.path, 'specs', 'user_profile', 'mini-spec.md'))
            .existsSync(),
        isTrue,
      );
      expect(
        File(p.join(directory.path, 'specs', 'user_profile', 'tasks.md'))
            .existsSync(),
        isTrue,
      );
    });
  });
}
