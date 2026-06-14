import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/audit_command.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/create_feature_command.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/doctor_command.dart';
import 'package:flutter_pragmatic_architecture_kit/commands/install_command.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';

void main(List<String> arguments) async {
  final logger = Logger();
  final runner = CommandRunner<void>(
    'fpt',
    'Flutter Pragmatic Architecture Toolkit.',
  )
    ..addCommand(InstallCommand(logger: logger))
    ..addCommand(DoctorCommand(logger: logger))
    ..addCommand(AuditCommand(logger: logger))
    ..addCommand(CreateFeatureCommand(logger: logger));

  try {
    await runner.run(arguments);
  } on UsageException catch (error) {
    logger.error(error.message);
    logger.info(error.usage);
  }
}
