import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/generators/ai_context_generator.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('AiContextGenerator', () {
    test('generates current_context.md from existing specs', () {
      final directory = Directory.systemTemp.createTempSync('fpt_context_');
      addTearDown(() => directory.deleteSync(recursive: true));
      final specDirectory = Directory(
        p.join(directory.path, 'specs', '001-customer-profile'),
      )..createSync(recursive: true);

      File(p.join(specDirectory.path, 'spec.md')).writeAsStringSync('Objetivo');
      File(p.join(specDirectory.path, 'plan.md')).writeAsStringSync('Plan');
      File(p.join(specDirectory.path, 'tasks.md')).writeAsStringSync('Tasks');
      File(p.join(specDirectory.path, 'data-model.md'))
          .writeAsStringSync('Data');

      final result = const AiContextGenerator().generate(
        projectRoot: directory.path,
        featureId: '001-customer-profile',
      );

      final output = File(result.outputPath);
      expect(output.existsSync(), isTrue);
      expect(output.readAsStringSync(), contains('Contexto Actual de Feature'));
      expect(output.readAsStringSync(), contains('001-customer-profile'));
    });
  });
}
