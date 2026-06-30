import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/services/architecture_validator_service.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('ArchitectureValidatorService', () {
    test('validates a complete spec and regenerates missing context', () {
      final directory = Directory.systemTemp.createTempSync('fpt_validate_');
      addTearDown(() => directory.deleteSync(recursive: true));
      final specDirectory = Directory(
        p.join(directory.path, 'specs', '001-customer-profile'),
      )..createSync(recursive: true);

      File(p.join(specDirectory.path, 'spec.md')).writeAsStringSync('Objetivo');
      File(p.join(specDirectory.path, 'plan.md')).writeAsStringSync('Plan');
      File(p.join(specDirectory.path, 'tasks.md')).writeAsStringSync('Tasks');
      File(p.join(specDirectory.path, 'data-model.md'))
          .writeAsStringSync('Data');

      final result = const ArchitectureValidatorService().validate(
        projectRoot: directory.path,
        featureId: '001-customer-profile',
      );

      expect(result.hasErrors, isFalse);
      expect(
        File(p.join(
                directory.path, '.agents', 'generated', 'current_context.md'))
            .existsSync(),
        isTrue,
      );
      expect(
        result.warnings.any((warning) => warning.contains('se regenero')),
        isTrue,
      );
    });

    test('returns errors for an incomplete spec', () {
      final directory = Directory.systemTemp.createTempSync('fpt_validate_');
      addTearDown(() => directory.deleteSync(recursive: true));
      final specDirectory = Directory(
        p.join(directory.path, 'specs', '001-customer-profile'),
      )..createSync(recursive: true);

      File(p.join(specDirectory.path, 'spec.md')).writeAsStringSync('Objetivo');

      final result = const ArchitectureValidatorService().validate(
        projectRoot: directory.path,
        featureId: '001-customer-profile',
      );

      expect(result.hasErrors, isTrue);
      expect(
        result.errors,
        contains(
            'Falta el archivo obligatorio specs/001-customer-profile/plan.md.'),
      );
      expect(
        result.errors,
        contains(
            'Falta el archivo obligatorio specs/001-customer-profile/tasks.md.'),
      );
    });
  });
}
