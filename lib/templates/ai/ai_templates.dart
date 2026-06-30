class AiTemplates {
  const AiTemplates._();

  static const agentFiles = {
    'agents/flutter_architect.md': '''
# Agente: Flutter Architect

## Mision

Definir y proteger la arquitectura Flutter del proyecto.

## Responsabilidades

- Mantener la separacion entre presentacion, dominio y datos.
- Verificar que el flujo sea: UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model.
- Revisar que los BLoC no conozcan detalles de red, almacenamiento o serializacion.
- Asegurar que repositories, providers, mappers y modelos tengan responsabilidades claras.
- Proponer estructuras simples, testeables y sostenibles.

## Salida esperada

Entregar decisiones tecnicas concretas, riesgos arquitectonicos y una secuencia de implementacion.
''',
    'agents/flutter_feature_builder.md': '''
# Agente: Flutter Feature Builder

## Mision

Implementar features Flutter siguiendo las especificaciones en `specs/` y las reglas del proyecto.

## Responsabilidades

- Leer el contexto generado antes de modificar codigo.
- Crear modelos, mappers, providers, repositories, BLoC y UI en ese orden cuando aplique.
- Mantener widgets libres de consumo directo de APIs o almacenamiento.
- Representar estados de carga, exito, vacio y error cuando correspondan.
- Dejar pruebas enfocadas en comportamiento observable.

## Salida esperada

Informar archivos modificados, decisiones tomadas y validaciones pendientes.
''',
    'agents/flutter_code_reviewer.md': '''
# Agente: Flutter Code Reviewer

## Mision

Revisar cambios Flutter con foco en bugs, regresiones, limites de arquitectura y pruebas faltantes.

## Responsabilidades

- Priorizar hallazgos por severidad.
- Detectar acceso directo a datos desde presentacion.
- Revisar manejo de errores y estados asincronos.
- Confirmar que repositories y providers no mezclen responsabilidades.
- Solicitar pruebas cuando el riesgo lo justifique.

## Salida esperada

Lista accionable de hallazgos, riesgos residuales y validaciones recomendadas.
''',
    'agents/flutter_test_engineer.md': '''
# Agente: Flutter Test Engineer

## Mision

Definir y mantener pruebas utiles para features Flutter.

## Responsabilidades

- Cubrir transiciones principales del BLoC.
- Validar mappers con datos completos, incompletos y erroneos.
- Probar repositories con providers falsos.
- Probar widgets criticos contra estados de UI.
- Evitar pruebas fragiles acopladas a detalles privados.

## Salida esperada

Plan de pruebas, fixtures minimos y comandos de validacion.
''',
  };

  static const ruleFiles = {
    'rules/flutter_architecture.md': '''
# Regla: Arquitectura Flutter

La arquitectura objetivo es:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Reglas obligatorias

- La UI solo renderiza estado y despacha intenciones.
- El BLoC coordina estados y casos de uso de la feature.
- El Repository expone metodos con lenguaje de producto.
- El Provider encapsula APIs, almacenamiento local o servicios externos.
- El Mapper transforma datos externos hacia modelos internos.
- El Model no depende de presentacion ni infraestructura.
''',
    'rules/bloc_pattern.md': '''
# Regla: BLoC

## Reglas obligatorias

- Todo flujo asincrono debe representar estados claros.
- Usar loading, success, empty y error cuando el caso lo requiera.
- No parsear respuestas de API dentro del BLoC.
- No acceder a almacenamiento local desde widgets.
- Mantener estados simples de inspeccionar en pruebas.
''',
    'rules/api_integration.md': '''
# Regla: Integracion API

## Reglas obligatorias

- Toda llamada de red debe vivir en providers.
- Los widgets no deben importar clientes HTTP ni SDKs de datos.
- Los repositories traducen errores tecnicos a fallos comprensibles para la feature.
- Los mappers aislan cambios de contrato externo.
''',
    'rules/naming_conventions.md': '''
# Regla: Convenciones de nombres

## Archivos

- `*_page.dart` para pantallas.
- `*_widget.dart` para piezas visuales.
- `*_bloc.dart`, `*_event.dart`, `*_state.dart` para BLoC.
- `*_repository.dart` para orchestration de datos.
- `*_provider.dart` para fuentes concretas.
- `*_mapper.dart` para conversiones.
- `*_model.dart` para datos internos.
''',
    'rules/error_handling.md': '''
# Regla: Manejo de errores

## Reglas obligatorias

- No ocultar errores silenciosamente.
- Convertir errores tecnicos en estados o fallos accionables.
- Mantener mensajes de usuario separados de detalles de diagnostico.
- Incluir estrategia de reintento cuando el flujo lo necesite.
''',
    'rules/testing.md': '''
# Regla: Pruebas

## Reglas obligatorias

- Cubrir el camino exitoso principal.
- Cubrir al menos un caso de error relevante.
- Probar mappers con datos incompletos cuando existan campos opcionales.
- Probar BLoC por transiciones de estado.
- Ejecutar validaciones antes de finalizar.
''',
  };

  static const skillFiles = {
    'skills/create_feature.md': '''
# Skill: Crear Feature

## Pasos

1. Leer `spec.md`, `plan.md`, `tasks.md` y `data-model.md`.
2. Confirmar el contexto generado.
3. Crear modelos, mappers, providers, repositories, BLoC y UI.
4. Agregar pruebas del flujo principal y de errores.
5. Ejecutar validaciones.
''',
    'skills/consume_api.md': '''
# Skill: Consumir API

## Pasos

1. Definir contrato de datos esperado.
2. Implementar provider para la fuente externa.
3. Implementar mapper hacia modelos internos.
4. Exponer repository con lenguaje de feature.
5. Manejar errores tecnicos en la capa adecuada.
''',
    'skills/create_bloc.md': '''
# Skill: Crear BLoC

## Pasos

1. Definir eventos o acciones.
2. Definir estados: inicial, loading, success, empty y error cuando aplique.
3. Inyectar repository.
4. Cubrir transiciones con pruebas.
''',
    'skills/create_form.md': '''
# Skill: Crear Formulario

## Pasos

1. Definir campos y reglas de validacion.
2. Mantener validacion visible en estado.
3. Enviar datos mediante BLoC.
4. Mostrar errores recuperables y estado de envio.
''',
    'skills/create_local_storage.md': '''
# Skill: Crear Almacenamiento Local

## Pasos

1. Definir que datos se guardan y por cuanto tiempo.
2. Encapsular almacenamiento en provider.
3. Mapear datos persistidos a modelos internos.
4. Evitar acceso directo desde widgets.
''',
    'skills/debug_flutter.md': '''
# Skill: Depurar Flutter

## Pasos

1. Reproducir el estado.
2. Ubicar la capa responsable.
3. Revisar logs y estados emitidos.
4. Agregar prueba de regresion.
5. Corregir en el limite arquitectonico correcto.
''',
  };

  static const projectContext = '''
# Contexto del Proyecto

Este proyecto usa una arquitectura Flutter pragmatica por capas:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Reglas generales

- Implementar features desde especificaciones ubicadas en `specs/`.
- Mantener los limites entre presentacion, dominio y datos.
- Preferir codigo simple, testeable y explicito.
- Generar contexto antes de pedir implementaciones asistidas por IA.
- Validar arquitectura antes de cerrar una tarea.
''';

  static const rootAgents = '''
# AGENTS

Este archivo orienta el trabajo asistido por IA en proyectos Flutter.

## Arquitectura objetivo

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Instrucciones para IA

- Leer `.agents/generated/current_context.md` antes de implementar una feature.
- Respetar las reglas en `.agents/rules/`.
- Usar skills de `.agents/skills/` segun la tarea.
- No consumir APIs, almacenamiento o SDKs de datos directamente desde widgets.
- Mantener BLoC, repositories, providers, mappers y modelos con responsabilidades claras.
- Agregar o actualizar pruebas cuando el cambio modifique comportamiento.
- Ejecutar validaciones antes de finalizar.
''';
}
