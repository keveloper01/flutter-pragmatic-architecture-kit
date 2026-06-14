import 'dart:io';

import 'package:path/path.dart' as p;

class FileCopier {
  const FileCopier();

  CopyResult copyDirectory({
    required String sourcePath,
    required String targetPath,
    bool overwrite = false,
    bool makeScriptsExecutable = false,
  }) {
    final sourceDirectory = Directory(sourcePath);
    if (!sourceDirectory.existsSync()) {
      throw FileSystemException('Source directory does not exist.', sourcePath);
    }

    var copiedFiles = 0;
    var overwrittenFiles = 0;
    var skippedFiles = 0;
    var executableScripts = 0;
    var createdDirectories = 0;

    for (final entity in sourceDirectory.listSync(recursive: true)) {
      if (entity is Directory) {
        final relativePath = p.relative(entity.path, from: sourcePath);
        final targetDirectory = Directory(p.join(targetPath, relativePath));
        if (!targetDirectory.existsSync()) {
          targetDirectory.createSync(recursive: true);
          createdDirectories++;
        }
        continue;
      }

      if (entity is! File) {
        continue;
      }

      final relativePath = p.relative(entity.path, from: sourcePath);
      final targetFile = File(p.join(targetPath, relativePath));
      final targetExists = targetFile.existsSync();

      if (targetExists && !overwrite) {
        skippedFiles++;
        if (makeScriptsExecutable && _isShellScriptInScripts(relativePath)) {
          _makeExecutable(targetFile);
          executableScripts++;
        }
        continue;
      }

      targetFile.parent.createSync(recursive: true);
      entity.copySync(targetFile.path);

      if (targetExists) {
        overwrittenFiles++;
      } else {
        copiedFiles++;
      }

      if (makeScriptsExecutable && _isShellScriptInScripts(relativePath)) {
        _makeExecutable(targetFile);
        executableScripts++;
      }
    }

    return CopyResult(
      createdDirectories: createdDirectories,
      copiedFiles: copiedFiles,
      overwrittenFiles: overwrittenFiles,
      skippedFiles: skippedFiles,
      executableScripts: executableScripts,
    );
  }

  bool _isShellScriptInScripts(String relativePath) {
    return p.extension(relativePath) == '.sh' &&
        p.split(relativePath).contains('scripts');
  }

  void _makeExecutable(File file) {
    final result = Process.runSync('/bin/chmod', ['u+x', file.path]);
    if (result.exitCode != 0) {
      throw FileSystemException(
        'Could not make script executable: ${result.stderr}',
        file.path,
      );
    }
  }
}

class CopyResult {
  const CopyResult({
    required this.createdDirectories,
    required this.copiedFiles,
    required this.overwrittenFiles,
    required this.skippedFiles,
    required this.executableScripts,
  });

  final int createdDirectories;
  final int copiedFiles;
  final int overwrittenFiles;
  final int skippedFiles;
  final int executableScripts;
}
