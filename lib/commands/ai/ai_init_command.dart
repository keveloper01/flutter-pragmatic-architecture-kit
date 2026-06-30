import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:flutter_pragmatic_architecture_kit/services/ai_template_installer_service.dart';

class AiInitCommand extends Command<void> {
  AiInitCommand({
    required Logger logger,
    required ProjectDetector projectDetector,
    AiTemplateInstallerService installer = const AiTemplateInstallerService(),
  })  : _logger = logger,
        _projectDetector = projectDetector,
        _installer = installer;

  final Logger _logger;
  final ProjectDetector _projectDetector;
  final AiTemplateInstallerService _installer;

  @override
  String get name => 'init';

  @override
  String get description =>
      'Creates AI agent rules, skills and project context.';

  @override
  void run() {
    final project = _projectDetector.detect();
    if (!project.isFlutterProject) {
      _logger.error('La carpeta actual no es un proyecto Flutter valido.');
      exitCode = 1;
      return;
    }

    final result = _installer.install(projectRoot: project.rootPath);

    _logger.success('AI context initialized.');
    _logger.detail('Directories created: ${result.createdDirectories}');
    _logger.detail('Files created: ${result.createdFiles}');
    _logger.detail('Files existing: ${result.existingFiles}');
    _logger.info('Next step: run fpt ai context --feature <feature-id>.');
  }
}
