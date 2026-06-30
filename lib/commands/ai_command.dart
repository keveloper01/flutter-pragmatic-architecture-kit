import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/ai/ai_context_command.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/ai/ai_init_command.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/ai/ai_validate_command.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';

class AiCommand extends Command<void> {
  AiCommand({
    required Logger logger,
    ProjectDetector? projectDetector,
  }) {
    final detector = projectDetector ?? const ProjectDetector();
    addSubcommand(AiInitCommand(logger: logger, projectDetector: detector));
    addSubcommand(AiContextCommand(logger: logger, projectDetector: detector));
    addSubcommand(AiValidateCommand(logger: logger, projectDetector: detector));
  }

  @override
  String get name => 'ai';

  @override
  String get description => 'Prepares AI-assisted Flutter development context.';
}
