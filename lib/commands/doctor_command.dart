import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:path/path.dart' as p;

class DoctorCommand extends Command<void> {
  DoctorCommand({
    required Logger logger,
    ProjectDetector? projectDetector,
  })  : _logger = logger,
        _projectDetector = projectDetector ?? const ProjectDetector();

  final Logger _logger;
  final ProjectDetector _projectDetector;

  @override
  String get name => 'doctor';

  @override
  String get description => 'Checks whether the current directory can use fpt.';

  @override
  void run() {
    final project = _projectDetector.detect();
    final errors = <String>[];

    if (!project.hasPubspec) {
      errors.add('pubspec.yaml was not found in the current directory.');
    } else if (!project.isFlutterProject) {
      errors.add(
        'pubspec.yaml exists, but this does not look like a Flutter project.',
      );
    }

    if (!Directory(p.join(project.rootPath, 'lib')).existsSync()) {
      errors.add('lib/ directory was not found in the current directory.');
    }

    for (final relativePath in _requiredToolkitPaths) {
      final path = p.join(project.rootPath, relativePath);
      final exists = File(path).existsSync() || Directory(path).existsSync();
      if (!exists) {
        errors.add('$relativePath was not found. Run fpt install first.');
      }
    }

    if (errors.isNotEmpty) {
      _logger.error('Doctor found ${errors.length} issue(s).');
      for (final error in errors) {
        _logger.detail(error);
      }
      exitCode = 1;
      return;
    }

    _logger.success('Flutter project and toolkit structure detected.');
    _logger.detail('Project root: ${project.rootPath}');
  }

  static const _requiredToolkitPaths = [
    'AGENTS.md',
    'CLAUDE.md',
    'GEMINI.md',
    'STARTER-AUDIT.md',
    '.agents',
    'docs',
    'specs',
    'templates',
    'scripts',
    'wiki',
  ];
}
