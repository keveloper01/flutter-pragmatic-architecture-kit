import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/services/context_builder_service.dart';
import 'package:flutter_pragmatic_architecture_kit/services/spec_reader_service.dart';
import 'package:path/path.dart' as p;

class AiContextGenerator {
  const AiContextGenerator({
    SpecReaderService specReader = const SpecReaderService(),
    ContextBuilderService contextBuilder = const ContextBuilderService(),
  })  : _specReader = specReader,
        _contextBuilder = contextBuilder;

  final SpecReaderService _specReader;
  final ContextBuilderService _contextBuilder;

  AiContextResult generate({
    required String projectRoot,
    required String featureId,
  }) {
    final spec =
        _specReader.read(projectRoot: projectRoot, featureId: featureId);
    final content = _contextBuilder.build(spec);
    final outputFile = File(
      p.join(projectRoot, '.agents', 'generated', 'current_context.md'),
    );

    outputFile.parent.createSync(recursive: true);
    outputFile.writeAsStringSync(content);

    return AiContextResult(
      outputPath: outputFile.path,
      spec: spec,
      warnings: spec.warnings,
    );
  }
}

class AiContextResult {
  const AiContextResult({
    required this.outputPath,
    required this.spec,
    required this.warnings,
  });

  final String outputPath;
  final FeatureSpec spec;
  final List<String> warnings;
}
