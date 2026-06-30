import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/services/spec_reader_service.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('SpecReaderService', () {
    test('reads a complete feature specification', () {
      final directory = Directory.systemTemp.createTempSync('fpt_spec_');
      addTearDown(() => directory.deleteSync(recursive: true));
      final specDirectory = Directory(
        p.join(directory.path, 'specs', '001-customer-profile'),
      )..createSync(recursive: true);

      File(p.join(specDirectory.path, 'spec.md')).writeAsStringSync('Objetivo');
      File(p.join(specDirectory.path, 'plan.md')).writeAsStringSync('Plan');
      File(p.join(specDirectory.path, 'tasks.md')).writeAsStringSync('Tasks');
      File(p.join(specDirectory.path, 'data-model.md'))
          .writeAsStringSync('Data');

      final spec = const SpecReaderService().read(
        projectRoot: directory.path,
        featureId: '001-customer-profile',
      );

      expect(spec.exists, isTrue);
      expect(spec.isComplete, isTrue);
      expect(spec.files['spec.md'], 'Objetivo');
      expect(spec.warnings, isEmpty);
    });

    test('reports warnings for an incomplete feature specification', () {
      final directory = Directory.systemTemp.createTempSync('fpt_spec_');
      addTearDown(() => directory.deleteSync(recursive: true));
      final specDirectory = Directory(
        p.join(directory.path, 'specs', '001-customer-profile'),
      )..createSync(recursive: true);

      File(p.join(specDirectory.path, 'spec.md')).writeAsStringSync('Objetivo');

      final spec = const SpecReaderService().read(
        projectRoot: directory.path,
        featureId: '001-customer-profile',
      );

      expect(spec.exists, isTrue);
      expect(spec.isComplete, isFalse);
      expect(
          spec.warnings, contains('Falta specs/001-customer-profile/plan.md.'));
      expect(spec.warnings,
          contains('Falta specs/001-customer-profile/tasks.md.'));
    });
  });
}
