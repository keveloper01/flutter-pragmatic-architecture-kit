import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:path/path.dart' as p;

class AuditCommand extends Command<void> {
  AuditCommand({
    required Logger logger,
    ProjectDetector? projectDetector,
  })  : _logger = logger,
        _projectDetector = projectDetector ?? const ProjectDetector();

  final Logger _logger;
  final ProjectDetector _projectDetector;

  @override
  String get name => 'audit';

  @override
  String get description =>
      'Audits a Flutter project against the toolkit conventions.';

  @override
  void run() {
    final project = _projectDetector.detect();
    final errors = <String>[];

    _validateProjectShape(project, errors);
    _validateToolkitStructure(project.rootPath, errors);
    _validateNoReactOrWebReferences(project.rootPath, errors);
    _validatePresentationBoundaries(project.rootPath, errors);

    if (errors.isEmpty) {
      _logger.success('Audit passed.');
      _logger.detail('Project: ${project.rootPath}');
      return;
    }

    _logger.error('Audit failed with ${errors.length} error(s).');
    for (final error in errors) {
      _logger.detail(error);
    }

    exitCode = 1;
  }

  void _validateProjectShape(ProjectInfo project, List<String> errors) {
    if (!project.hasPubspec) {
      errors.add('pubspec.yaml is required at the project root.');
    } else if (!project.isFlutterProject) {
      errors.add(
          'pubspec.yaml exists, but this does not look like a Flutter project.');
    }

    if (!Directory(p.join(project.rootPath, 'lib')).existsSync()) {
      errors.add('lib/ directory is required at the project root.');
    }
  }

  void _validateToolkitStructure(String rootPath, List<String> errors) {
    final requiredPaths = [
      'AGENTS.md',
      'specs',
      'templates',
      'wiki',
      '.agents',
    ];

    for (final relativePath in requiredPaths) {
      final path = p.join(rootPath, relativePath);
      final exists = File(path).existsSync() || Directory(path).existsSync();
      if (!exists) {
        errors.add('$relativePath is required by the installed toolkit.');
      }
    }
  }

  void _validateNoReactOrWebReferences(String rootPath, List<String> errors) {
    final toolkitPaths = [
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
    final forbiddenTerms = [
      'React',
      'hooks',
      'useState',
      'useEffect',
      'Vite',
      'Tailwind',
      'Zustand',
      'npm',
      'yarn',
      'package.json',
    ];

    for (final file in _filesUnder(rootPath, toolkitPaths)) {
      final content = file.readAsStringSync();
      final relativePath = p.relative(file.path, from: rootPath);

      for (final term in forbiddenTerms) {
        if (content.contains(term)) {
          errors.add(
              '$relativePath contains forbidden React/Web reference: $term.');
        }
      }
    }
  }

  void _validatePresentationBoundaries(String rootPath, List<String> errors) {
    final presentationPath = p.join(rootPath, 'lib', 'presentation');
    final presentationDirectory = Directory(presentationPath);
    if (!presentationDirectory.existsSync()) {
      return;
    }

    final forbiddenPatterns = <String, RegExp>{
      'Dio': RegExp(r'\bDio\b|package:dio/'),
      'http': RegExp(r"package:http/|\bhttp\."),
      'FirebaseFirestore': RegExp(r'\bFirebaseFirestore\b|cloud_firestore'),
      'Supabase': RegExp(r'\bSupabase\b|\bsupabase\b|supabase_flutter'),
      'Hive': RegExp(r'\bHive\b|package:hive/'),
      'SharedPreferences': RegExp(r'\bSharedPreferences\b|shared_preferences'),
    };

    for (final file in _filesUnder(rootPath, ['lib/presentation'])) {
      final content = file.readAsStringSync();
      final relativePath = p.relative(file.path, from: rootPath);

      for (final entry in forbiddenPatterns.entries) {
        if (entry.value.hasMatch(content)) {
          errors.add(
            '$relativePath accesses ${entry.key}. Presentation must use BLoC and repositories instead.',
          );
        }
      }
    }
  }

  Iterable<File> _filesUnder(
      String rootPath, List<String> relativePaths) sync* {
    for (final relativePath in relativePaths) {
      final entityPath = p.join(rootPath, relativePath);
      final file = File(entityPath);
      if (file.existsSync()) {
        yield file;
        continue;
      }

      final directory = Directory(entityPath);
      if (!directory.existsSync()) {
        continue;
      }

      yield* _filesInDirectory(directory, rootPath);
    }
  }

  Iterable<File> _filesInDirectory(Directory directory, String rootPath) sync* {
    for (final entity in directory.listSync(recursive: false)) {
      if (_isExcluded(entity.path, rootPath)) {
        continue;
      }

      if (entity is File) {
        yield entity;
      } else if (entity is Directory) {
        yield* _filesInDirectory(entity, rootPath);
      }
    }
  }

  bool _isExcluded(String path, String rootPath) {
    final relativeParts = p.split(p.relative(path, from: rootPath));
    const excludedDirectories = {
      '.git',
      '.dart_tool',
      'build',
      'android',
      'ios',
      'windows',
      'macos',
      'linux',
      'web',
    };

    return relativeParts.any(excludedDirectories.contains);
  }
}
