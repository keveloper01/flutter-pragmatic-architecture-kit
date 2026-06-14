import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/file_copier.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:path/path.dart' as p;

class InstallCommand extends Command<void> {
  InstallCommand({
    required Logger logger,
    ProjectDetector? projectDetector,
    FileCopier? fileCopier,
    String? toolkitPath,
  })  : _logger = logger,
        _projectDetector = projectDetector ?? const ProjectDetector(),
        _fileCopier = fileCopier ?? const FileCopier(),
        _toolkitPath = toolkitPath {
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'Overwrite files that already exist.',
      negatable: false,
    );
  }

  final Logger _logger;
  final ProjectDetector _projectDetector;
  final FileCopier _fileCopier;
  final String? _toolkitPath;

  @override
  String get name => 'install';

  @override
  String get description =>
      'Installs the architecture toolkit in a Flutter project.';

  @override
  void run() {
    final project = _projectDetector.detect();
    if (!project.isFlutterProject) {
      _logger.error('Current directory is not a Flutter project.');
      _logger.info(
          'Run this command from a folder that contains a Flutter pubspec.yaml.');
      return;
    }

    final force = argResults?['force'] as bool? ?? false;
    final toolkitPath = _toolkitPath ?? _resolveToolkitPath();
    final result = _fileCopier.copyDirectory(
      sourcePath: toolkitPath,
      targetPath: project.rootPath,
      overwrite: force,
      makeScriptsExecutable: true,
    );

    _logger.success('Toolkit installation finished.');
    _logger.detail('Project: ${project.rootPath}');
    _logger.detail('Source: $toolkitPath');
    _logger.detail('Directories created: ${result.createdDirectories}');
    _logger.detail('Copied: ${result.copiedFiles}');
    _logger.detail('Overwritten: ${result.overwrittenFiles}');
    _logger.detail('Skipped: ${result.skippedFiles}');
    _logger.detail('Executable scripts: ${result.executableScripts}');

    if (result.skippedFiles > 0 && !force) {
      _logger.info('Use --force to overwrite existing files.');
    }
  }

  String _resolveToolkitPath() {
    final scriptPath = Platform.script.toFilePath();
    final packageRoot = _findPackageRoot(File(scriptPath).parent.path);
    final toolkitPath = p.join(packageRoot, 'toolkit');

    if (!Directory(toolkitPath).existsSync()) {
      throw FileSystemException(
          'Toolkit directory does not exist.', toolkitPath);
    }

    return toolkitPath;
  }

  String _findPackageRoot(String startPath) {
    var currentPath = p.normalize(startPath);

    while (true) {
      final toolkitDirectory = Directory(p.join(currentPath, 'toolkit'));
      final toolkitManifest = File(p.join(toolkitDirectory.path, 'AGENTS.md'));
      if (toolkitDirectory.existsSync() && toolkitManifest.existsSync()) {
        return currentPath;
      }

      final parentPath = p.dirname(currentPath);
      if (parentPath == currentPath) {
        break;
      }
      currentPath = parentPath;
    }

    final scriptPath = Platform.script.toFilePath();
    return p.dirname(p.dirname(scriptPath));
  }
}
