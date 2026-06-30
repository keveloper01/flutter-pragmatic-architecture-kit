import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/templates/ai/ai_templates.dart';
import 'package:path/path.dart' as p;

class AiTemplateInstallerService {
  const AiTemplateInstallerService();

  AiInitResult install({required String projectRoot}) {
    final files = {
      ...AiTemplates.agentFiles,
      ...AiTemplates.ruleFiles,
      ...AiTemplates.skillFiles,
      'project_context.md': AiTemplates.projectContext,
    };

    var createdDirectories = 0;
    var existingFiles = 0;
    var createdFiles = 0;

    for (final relativeDirectory in [
      '.agents',
      p.join('.agents', 'agents'),
      p.join('.agents', 'rules'),
      p.join('.agents', 'skills'),
      p.join('.agents', 'generated'),
    ]) {
      final directory = Directory(p.join(projectRoot, relativeDirectory));
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
        createdDirectories++;
      }
    }

    for (final entry in files.entries) {
      final file = File(p.join(projectRoot, '.agents', entry.key));
      if (file.existsSync()) {
        existingFiles++;
        continue;
      }
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(entry.value);
      createdFiles++;
    }

    final rootAgents = File(p.join(projectRoot, 'AGENTS.md'));
    if (rootAgents.existsSync()) {
      existingFiles++;
    } else {
      rootAgents.writeAsStringSync(AiTemplates.rootAgents);
      createdFiles++;
    }

    return AiInitResult(
      createdDirectories: createdDirectories,
      createdFiles: createdFiles,
      existingFiles: existingFiles,
    );
  }
}

class AiInitResult {
  const AiInitResult({
    required this.createdDirectories,
    required this.createdFiles,
    required this.existingFiles,
  });

  final int createdDirectories;
  final int createdFiles;
  final int existingFiles;
}
