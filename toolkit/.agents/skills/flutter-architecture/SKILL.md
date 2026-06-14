# Flutter Architecture Skill

Use this skill when designing or reviewing Flutter feature structure.

## Architecture

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Steps

1. Identify the feature boundary and user outcome.
2. Define the model and state shape.
3. Decide repository responsibilities in product language.
4. Decide provider responsibilities by data source.
5. Define mapper responsibilities for source conversion.
6. Confirm UI only depends on BLoC-facing state.
7. Note tests needed for the highest-risk behavior.

## Guardrails

- Do not let UI call providers directly.
- Do not let BLoC parse raw response structures.
- Do not let repositories expose source-shaped maps to presentation.
- Do not create shared abstractions before a second real use case exists.
