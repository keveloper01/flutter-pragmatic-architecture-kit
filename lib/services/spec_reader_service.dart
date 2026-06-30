import 'dart:io';

import 'package:path/path.dart' as p;

class SpecReaderService {
  const SpecReaderService();

  FeatureSpec read({
    required String projectRoot,
    required String featureId,
  }) {
    final featurePath = p.join(projectRoot, 'specs', featureId);
    final featureDirectory = Directory(featurePath);
    final warnings = <String>[];
    final files = <String, String>{};

    if (!featureDirectory.existsSync()) {
      warnings.add('No existe la carpeta specs/$featureId.');
      return FeatureSpec(
        featureId: featureId,
        featurePath: featurePath,
        exists: false,
        files: files,
        warnings: warnings,
      );
    }

    for (final fileName in requiredSpecFiles) {
      final file = File(p.join(featurePath, fileName));
      if (!file.existsSync()) {
        warnings.add('Falta specs/$featureId/$fileName.');
        continue;
      }

      final content = file.readAsStringSync();
      files[fileName] = content;
      if (content.trim().isEmpty) {
        warnings.add('El archivo specs/$featureId/$fileName esta vacio.');
      }
    }

    final dataModel = File(p.join(featurePath, 'data-model.md'));
    if (dataModel.existsSync()) {
      final content = dataModel.readAsStringSync();
      files['data-model.md'] = content;
      if (content.trim().isEmpty) {
        warnings.add('El archivo specs/$featureId/data-model.md esta vacio.');
      }
    } else {
      warnings.add('Falta specs/$featureId/data-model.md.');
    }

    return FeatureSpec(
      featureId: featureId,
      featurePath: featurePath,
      exists: true,
      files: files,
      warnings: warnings,
    );
  }

  static const requiredSpecFiles = ['spec.md', 'plan.md', 'tasks.md'];
}

class FeatureSpec {
  const FeatureSpec({
    required this.featureId,
    required this.featurePath,
    required this.exists,
    required this.files,
    required this.warnings,
  });

  final String featureId;
  final String featurePath;
  final bool exists;
  final Map<String, String> files;
  final List<String> warnings;

  bool get isComplete {
    return exists &&
        SpecReaderService.requiredSpecFiles.every(files.containsKey);
  }
}
