import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_pragmatic_architecture_kit/core/logger.dart';
import 'package:flutter_pragmatic_architecture_kit/core/project_detector.dart';
import 'package:path/path.dart' as p;

class CreateFeatureCommand extends Command<void> {
  CreateFeatureCommand({
    required Logger logger,
    ProjectDetector? projectDetector,
  })  : _logger = logger,
        _projectDetector = projectDetector ?? const ProjectDetector() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'Feature name to create.',
      valueHelp: 'feature_name',
    );
  }

  final Logger _logger;
  final ProjectDetector _projectDetector;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => const ['create-feature'];

  @override
  String get description =>
      'Creates a new feature following the toolkit structure.';

  @override
  void run() {
    final project = _projectDetector.detect();
    if (!project.isFlutterProject) {
      _logger.error('Current directory is not a Flutter project.');
      return;
    }

    final featureName = argResults?['name'] as String?;
    if (featureName == null || featureName.trim().isEmpty) {
      throw UsageException('Missing required option: --name.', usage);
    }

    final normalizedName = _normalizeFeatureName(featureName);
    if (normalizedName.isEmpty) {
      throw UsageException(
          'Feature name must contain letters or numbers.', usage);
    }

    final result = _createFeature(
      projectRoot: project.rootPath,
      featureName: normalizedName,
    );

    _logger.success('Feature scaffold ready: $normalizedName');
    _logger.detail('Directories created: ${result.createdDirectories}');
    _logger.detail('Directories existing: ${result.existingDirectories}');
    _logger.detail('Files created: ${result.createdFiles}');
    _logger.detail('Files skipped: ${result.skippedFiles}');
    _logger.info(
      'Next step: open specs/$normalizedName/mini-spec.md and define the '
      'Flutter states, repository contract, and provider source before writing UI.',
    );
  }

  FeatureCreationResult _createFeature({
    required String projectRoot,
    required String featureName,
  }) {
    final directories = [
      p.join('lib', 'domain', featureName, 'models'),
      p.join('lib', 'domain', featureName, 'mappers'),
      p.join('lib', 'domain', featureName, 'providers'),
      p.join('lib', 'domain', featureName, 'repositories'),
      p.join('lib', 'presentation', 'containers', featureName, 'bloc'),
      p.join('lib', 'presentation', 'containers', featureName, 'widgets'),
      p.join('specs', featureName),
    ];

    var createdDirectories = 0;
    var existingDirectories = 0;

    for (final relativePath in directories) {
      final directory = Directory(p.join(projectRoot, relativePath));
      if (directory.existsSync()) {
        existingDirectories++;
        continue;
      }

      directory.createSync(recursive: true);
      createdDirectories++;
    }

    var createdFiles = 0;
    var skippedFiles = 0;

    final specFiles = {
      p.join('specs', featureName, 'mini-spec.md'):
          _miniSpecContent(featureName),
      p.join('specs', featureName, 'tasks.md'): _tasksContent(featureName),
      p.join('specs', _aiSpecId(featureName), 'spec.md'): _aiSpecContent(),
      p.join('specs', _aiSpecId(featureName), 'plan.md'): _aiPlanContent(),
      p.join('specs', _aiSpecId(featureName), 'tasks.md'): _aiTasksContent(),
      p.join('specs', _aiSpecId(featureName), 'data-model.md'):
          _aiDataModelContent(),
    };

    for (final entry in specFiles.entries) {
      final file = File(p.join(projectRoot, entry.key));
      if (file.existsSync()) {
        skippedFiles++;
        continue;
      }

      file.parent.createSync(recursive: true);
      file.writeAsStringSync(entry.value);
      createdFiles++;
    }

    return FeatureCreationResult(
      createdDirectories: createdDirectories,
      existingDirectories: existingDirectories,
      createdFiles: createdFiles,
      skippedFiles: skippedFiles,
    );
  }

  String _normalizeFeatureName(String input) {
    final withWordBoundaries = input
        .trim()
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .toLowerCase();

    return withWordBoundaries
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  String _aiSpecId(String featureName) {
    return '001-${featureName.replaceAll('_', '-')}';
  }

  String _miniSpecContent(String featureName) {
    final title = _titleFromSnakeCase(featureName);

    return '''
# $title Mini Spec

## Outcome

Describe the user outcome this Flutter feature must deliver.

## Architecture

Target flow:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## State Model

- Initial:
- Loading:
- Success:
- Empty:
- Failure:

## Data Contract

- Repository methods:
- Provider source:
- Mapper responsibilities:
- Model fields:

## UX Notes

- Entry point:
- Loading behavior:
- Empty state:
- Error state:
- Retry behavior:

## Validation

- BLoC success path:
- BLoC failure path:
- Mapper edge cases:
- Critical widget behavior:
''';
  }

  String _tasksContent(String featureName) {
    final title = _titleFromSnakeCase(featureName);

    return '''
# $title Tasks

## Planning

- [ ] Confirm the feature outcome and entry point.
- [ ] Define loading, success, empty, and failure states.
- [ ] Define model fields and mapper rules.

## Domain

- [ ] Add models in `lib/domain/$featureName/models`.
- [ ] Add mappers in `lib/domain/$featureName/mappers`.
- [ ] Add providers in `lib/domain/$featureName/providers`.
- [ ] Add repositories in `lib/domain/$featureName/repositories`.

## Presentation

- [ ] Add BLoC files in `lib/presentation/containers/$featureName/bloc`.
- [ ] Add widgets in `lib/presentation/containers/$featureName/widgets`.
- [ ] Wire UI to BLoC state without direct provider access.

## Validation

- [ ] Add BLoC tests for success and failure.
- [ ] Add mapper tests for source data conversion.
- [ ] Run Flutter analysis.
- [ ] Run relevant Flutter tests.
''';
  }

  String _aiSpecContent() {
    return '''
# Especificacion de Feature

## Objetivo

Describe el resultado que debe lograr la feature.

## Problema que resuelve

Describe el problema de usuario o de producto que justifica esta feature.

## Alcance

Lista los comportamientos incluidos.

## Fuera de alcance

Lista decisiones o comportamientos que no forman parte de esta iteracion.

## Criterios de aceptacion

- [ ] La feature cumple el flujo principal esperado.
- [ ] Los estados de carga, exito, vacio y error estan definidos cuando corresponda.
- [ ] La implementacion respeta las capas del toolkit.

## Estados de interfaz

- Loading:
- Success:
- Empty:
- Error:

## Casos de error

- Error recuperable:
- Error no recuperable:
- Reintento:

## Dependencias

- APIs:
- Almacenamiento local:
- Permisos:
''';
  }

  String _aiPlanContent() {
    return '''
# Plan Tecnico

## Arquitectura propuesta

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Capas involucradas

- Presentacion:
- BLoC:
- Repository:
- Provider:
- Mapper:
- Model:

## Flujo de datos

Describe como se mueve la informacion entre capas.

## Integraciones externas

Describe APIs, almacenamiento local o servicios externos si aplican.

## Estrategia de manejo de errores

Describe errores esperados, mensajes y recuperacion.

## Estrategia de pruebas

Describe pruebas de BLoC, repository, mapper y widgets criticos.
''';
  }

  String _aiTasksContent() {
    return '''
# Tareas de Implementacion

## Pendientes

- [ ] Definir modelo de dominio
- [ ] Implementar provider
- [ ] Implementar repository
- [ ] Implementar mapper
- [ ] Implementar BLoC
- [ ] Implementar interfaz
- [ ] Agregar pruebas
- [ ] Ejecutar validaciones
''';
  }

  String _aiDataModelContent() {
    return '''
# Modelo de Datos

## Entidades

Describe entidades internas relevantes.

## Propiedades

Lista propiedades, tipos y nulabilidad.

## Reglas de validacion

Describe reglas de formato, obligatoriedad y consistencia.

## Mapeos

Describe conversiones entre datos externos y modelos internos.

## Ejemplos de datos

Incluye ejemplos genericos cuando ayuden a validar mappers.
''';
  }

  String _titleFromSnakeCase(String featureName) {
    return featureName
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

class FeatureCreationResult {
  const FeatureCreationResult({
    required this.createdDirectories,
    required this.existingDirectories,
    required this.createdFiles,
    required this.skippedFiles,
  });

  final int createdDirectories;
  final int existingDirectories;
  final int createdFiles;
  final int skippedFiles;
}
