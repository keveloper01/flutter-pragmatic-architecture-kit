import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:flutter_pragmatic_architecture_kit/services/architecture_validator_service.dart';

class AiValidateCommand extends Command<void> {
  AiValidateCommand({
    required Logger logger,
    required ProjectDetector projectDetector,
    ArchitectureValidatorService validator =
        const ArchitectureValidatorService(),
  })  : _logger = logger,
        _projectDetector = projectDetector,
        _validator = validator {
    argParser.addOption(
      'feature',
      help: 'Feature id under specs/.',
      valueHelp: '001-customer-profile',
    );
  }

  final Logger _logger;
  final ProjectDetector _projectDetector;
  final ArchitectureValidatorService _validator;

  @override
  String get name => 'validate';

  @override
  String get description => 'Validates generated AI context and architecture.';

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

    final result = _validator.validate(
      projectRoot: project.rootPath,
      featureId: featureId.trim(),
    );

    if (result.hasErrors) {
      _logger
          .error('AI validation failed with ${result.errors.length} error(s).');
      for (final error in result.errors) {
        _logger.detail(error);
      }
      exitCode = 1;
    } else {
      _logger.success('AI validation passed.');
    }

    for (final warning in result.warnings) {
      _logger.info('Warning: $warning');
    }
    for (final recommendation in result.recommendations) {
      _logger.info('Recommendation: $recommendation');
    }
  }
}
