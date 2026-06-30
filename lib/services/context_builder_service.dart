import 'package:flutter_pragmatic_architecture_kit/services/spec_reader_service.dart';

class ContextBuilderService {
  const ContextBuilderService();

  String build(FeatureSpec spec) {
    final buffer = StringBuffer()
      ..writeln('# Contexto Actual de Feature')
      ..writeln()
      ..writeln('## Feature')
      ..writeln()
      ..writeln('- Identificador: `${spec.featureId}`')
      ..writeln('- Ruta de especificacion: `${spec.featurePath}`')
      ..writeln()
      ..writeln('## Arquitectura obligatoria')
      ..writeln()
      ..writeln(
        'UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model',
      )
      ..writeln()
      ..writeln('## Reglas obligatorias relevantes')
      ..writeln()
      ..writeln(
          '- La presentacion no consume APIs ni almacenamiento directamente.')
      ..writeln('- El BLoC coordina estados y depende de repositories.')
      ..writeln('- Los repositories coordinan providers y mappers.')
      ..writeln('- Los providers encapsulan fuentes externas o locales.')
      ..writeln('- Los mappers convierten datos externos a modelos internos.')
      ..writeln('- Los modelos no dependen de UI ni infraestructura.')
      ..writeln()
      ..writeln('## Skills recomendadas')
      ..writeln()
      ..writeln('- `create_feature.md`')
      ..writeln('- `create_bloc.md`')
      ..writeln('- `consume_api.md` cuando exista integracion externa')
      ..writeln('- `create_local_storage.md` cuando exista persistencia local')
      ..writeln('- `debug_flutter.md` para diagnostico o regresiones')
      ..writeln()
      ..writeln('## Estructura esperada de archivos')
      ..writeln()
      ..writeln('- `lib/domain/<feature>/models/`')
      ..writeln('- `lib/domain/<feature>/mappers/`')
      ..writeln('- `lib/domain/<feature>/providers/`')
      ..writeln('- `lib/domain/<feature>/repositories/`')
      ..writeln('- `lib/presentation/containers/<feature>/bloc/`')
      ..writeln('- `lib/presentation/containers/<feature>/widgets/`')
      ..writeln()
      ..writeln('## Archivos que pueden modificarse')
      ..writeln()
      ..writeln('- Archivos dentro de la feature correspondiente.')
      ..writeln('- Specs de la feature cuando se clarifique alcance.')
      ..writeln('- Pruebas relacionadas con la feature.')
      ..writeln()
      ..writeln('## Validaciones antes de finalizar')
      ..writeln()
      ..writeln('- `fpt ai validate --feature ${spec.featureId}`')
      ..writeln('- `flutter format .`')
      ..writeln('- `flutter analyze`')
      ..writeln('- `flutter test`')
      ..writeln();

    _appendSection(
        buffer, 'Objetivo, alcance y criterios', spec.files['spec.md']);
    _appendSection(buffer, 'Plan tecnico', spec.files['plan.md']);
    _appendSection(buffer, 'Tareas pendientes', spec.files['tasks.md']);
    _appendSection(buffer, 'Modelo de datos', spec.files['data-model.md']);

    buffer
      ..writeln('## Advertencias')
      ..writeln();

    if (spec.warnings.isEmpty) {
      buffer.writeln('- Sin advertencias.');
    } else {
      for (final warning in spec.warnings) {
        buffer.writeln('- $warning');
      }
    }

    return buffer.toString();
  }

  void _appendSection(StringBuffer buffer, String title, String? content) {
    buffer
      ..writeln('## $title')
      ..writeln();

    if (content == null || content.trim().isEmpty) {
      buffer.writeln('_No hay informacion disponible._');
    } else {
      buffer.writeln(content.trim());
    }

    buffer.writeln();
  }
}
