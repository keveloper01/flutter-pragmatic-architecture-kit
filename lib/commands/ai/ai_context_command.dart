import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:flutter_pragmatic_architecture_kit/generators/ai_context_generator.dart';

class AiContextCommand extends Command<void> {
  AiContextCommand({
    required Logger logger,
    required ProjectDetector projectDetector,
    AiContextGenerator generator = const AiContextGenerator(),
  })  : _logger = logger,
        _projectDetector = projectDetector,
        _generator = generator {
    argParser.addOption(
      'feature',
      help: 'Feature id under specs/.',
      valueHelp: '001-customer-profile',
    );
  }

  final Logger _logger;
  final ProjectDetector _projectDetector;
  final AiContextGenerator _generator;

  @override
  String get name => 'context';

  @override
  String get description => 'Generates .agents/generated/current_context.md.';

  @override
  void run() {
    final featureId = argResults?['feature'] as String?;
    if (featureId == null || featureId.trim().isEmpty) {
      throw UsageException('Missing required option: --feature.', usage);
    }

    final project = _projectDetector.detect();
    if (!project.isFlutterProject) {
      _logger.error('La carpeta actual no es un proyecto Flutter valido.');
      exitCode = 1;
      return;
    }

    final result = _generator.generate(
      projectRoot: project.rootPath,
      featureId: featureId.trim(),
    );

    _logger.success('AI context generated.');
    _logger.detail('Output: ${result.outputPath}');

    for (final warning in result.warnings) {
      _logger.info('Warning: $warning');
    }
  }
}
