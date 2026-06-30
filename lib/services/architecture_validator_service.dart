import 'dart:io';

import 'package:flutter_pragmatic_architecture_kit/generators/ai_context_generator.dart';
import 'package:flutter_pragmatic_architecture_kit/services/spec_reader_service.dart';
import 'package:path/path.dart' as p;

class ArchitectureValidatorService {
  const ArchitectureValidatorService({
    SpecReaderService specReader = const SpecReaderService(),
    AiContextGenerator contextGenerator = const AiContextGenerator(),
  })  : _specReader = specReader,
        _contextGenerator = contextGenerator;

  final SpecReaderService _specReader;
  final AiContextGenerator _contextGenerator;

  AiValidationResult validate({
    required String projectRoot,
    required String featureId,
  }) {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];
    final spec =
        _specReader.read(projectRoot: projectRoot, featureId: featureId);

    if (!spec.exists) {
      errors.add('No existe specs/$featureId.');
      warnings.addAll(spec.warnings);
      return AiValidationResult(
        errors: errors,
        warnings: warnings,
        recommendations: recommendations,
      );
    }

    for (final fileName in SpecReaderService.requiredSpecFiles) {
      if (!spec.files.containsKey(fileName)) {
        errors.add('Falta el archivo obligatorio specs/$featureId/$fileName.');
      }
    }
    warnings
        .addAll(spec.warnings.where((warning) => !warning.contains('Falta')));

    final contextFile = File(
      p.join(projectRoot, '.agents', 'generated', 'current_context.md'),
    );
    if (!contextFile.existsSync()) {
      final result = _contextGenerator.generate(
        projectRoot: projectRoot,
        featureId: featureId,
      );
      warnings.add(
          'No existia current_context.md; se regenero en ${result.outputPath}.');
    }

    _validateLayerStructure(projectRoot, featureId, warnings, recommendations);
    _validatePresentationDataAccess(projectRoot, warnings);
    _validateBlocStates(projectRoot, featureId, warnings, recommendations);

    recommendations.add(
        'Estructura preparada para integrar luego flutter format, analyze y test.');

    return AiValidationResult(
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  void _validateLayerStructure(
    String projectRoot,
    String featureId,
    List<String> warnings,
    List<String> recommendations,
  ) {
    final name = _featureCodeName(featureId);
    final hasAnyCode =
        Directory(p.join(projectRoot, 'lib', 'domain', name)).existsSync() ||
            Directory(
              p.join(projectRoot, 'lib', 'presentation', 'containers', name),
            ).existsSync();

    if (!hasAnyCode) {
      recommendations.add(
        'No se encontro codigo para `$featureId`; crea la estructura con fpt feature --name cuando inicie la implementacion.',
      );
      return;
    }

    final expectedDirectories = [
      p.join('lib', 'domain', name, 'models'),
      p.join('lib', 'domain', name, 'mappers'),
      p.join('lib', 'domain', name, 'providers'),
      p.join('lib', 'domain', name, 'repositories'),
      p.join('lib', 'presentation', 'containers', name, 'bloc'),
      p.join('lib', 'presentation', 'containers', name, 'widgets'),
    ];

    for (final relativePath in expectedDirectories) {
      if (!Directory(p.join(projectRoot, relativePath)).existsSync()) {
        warnings.add('No se encontro la carpeta esperada `$relativePath`.');
      }
    }
  }

  void _validatePresentationDataAccess(
      String projectRoot, List<String> warnings) {
    final presentationDirectory =
        Directory(p.join(projectRoot, 'lib', 'presentation'));
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

    for (final entity in presentationDirectory.listSync(recursive: true)) {
      if (entity is! File || p.extension(entity.path) != '.dart') {
        continue;
      }
      final content = entity.readAsStringSync();
      final relativePath = p.relative(entity.path, from: projectRoot);
      for (final entry in forbiddenPatterns.entries) {
        if (entry.value.hasMatch(content)) {
          warnings.add(
            '$relativePath consume ${entry.key} directamente. Usa BLoC, repository y provider.',
          );
        }
      }
    }
  }

  void _validateBlocStates(
    String projectRoot,
    String featureId,
    List<String> warnings,
    List<String> recommendations,
  ) {
    final expectedTokens = ['loading', 'success', 'empty', 'error'];
    final blocDirectories = [
      Directory(
        p.join(
          projectRoot,
          'lib',
          'presentation',
          'containers',
          _featureCodeName(featureId),
          'bloc',
        ),
      ),
    ].where((directory) => directory.existsSync());

    for (final directory in blocDirectories) {
      final dartFiles = directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => p.extension(file.path) == '.dart')
          .toList();
      if (dartFiles.isEmpty) {
        recommendations.add(
            'La carpeta `${p.relative(directory.path, from: projectRoot)}` aun no tiene archivos BLoC.');
        continue;
      }

      final content = dartFiles
          .map((file) => file.readAsStringSync().toLowerCase())
          .join('\n');
      for (final token in expectedTokens) {
        if (!content.contains(token)) {
          warnings.add(
            'El BLoC en `${p.relative(directory.path, from: projectRoot)}` no evidencia estado `$token`.',
          );
        }
      }
    }
  }

  String _featureCodeName(String featureId) {
    final withoutNumericPrefix =
        featureId.replaceFirst(RegExp(r'^\d+[-_]?'), '');
    final normalized = withoutNumericPrefix.replaceAll('-', '_');
    if (normalized.trim().isNotEmpty) {
      return normalized;
    }

    return featureId.replaceAll('-', '_');
  }
}

class AiValidationResult {
  const AiValidationResult({
    required this.errors,
    required this.warnings,
    required this.recommendations,
  });

  final List<String> errors;
  final List<String> warnings;
  final List<String> recommendations;

  bool get hasErrors => errors.isNotEmpty;
}
