import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/services/ai_template_installer_service.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('AiTemplateInstallerService', () {
    test('creates agents, rules, skills and AGENTS.md', () {
      final directory = Directory.systemTemp.createTempSync('fpt_ai_init_');
      addTearDown(() => directory.deleteSync(recursive: true));

      final result = const AiTemplateInstallerService().install(
        projectRoot: directory.path,
      );

      expect(Directory(p.join(directory.path, '.agents')).existsSync(), isTrue);
      expect(
        File(p.join(
                directory.path, '.agents', 'agents', 'flutter_architect.md'))
            .existsSync(),
        isTrue,
      );
      expect(
        File(p.join(directory.path, '.agents', 'rules', 'bloc_pattern.md'))
            .existsSync(),
        isTrue,
      );
      expect(
        File(p.join(directory.path, '.agents', 'skills', 'create_feature.md'))
            .existsSync(),
        isTrue,
      );
      expect(
        Directory(p.join(directory.path, '.agents', 'generated')).existsSync(),
        isTrue,
      );
      expect(File(p.join(directory.path, 'AGENTS.md')).existsSync(), isTrue);
      expect(result.createdFiles, greaterThan(10));
    });
  });
}
