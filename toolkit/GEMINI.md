# Gemini Guidance

Act as a senior Flutter engineer. Favor direct, maintainable changes over broad rewrites.

The expected dependency direction is:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

Decision rules:

- UI should not call providers directly.
- BLoC should not know transport details.
- Repository should expose domain-oriented methods.
- Provider should expose source-oriented methods.
- Mapper should isolate schema changes from the rest of the feature.
- Model should be easy to construct in tests.

For each task, state the intended layer change before editing and verify the change with targeted tests or analysis.
