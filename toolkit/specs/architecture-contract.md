# Architecture Contract

Every feature should respect this dependency flow:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Allowed

- UI imports BLoC and presentation widgets.
- BLoC imports repositories and models.
- Repository imports providers, mappers, and models.
- Provider imports API, local storage, and source DTOs.
- Mapper imports source DTOs and models.
- Model imports only stable Dart or package primitives when necessary.

## Not Allowed

- UI importing providers directly.
- BLoC parsing raw API responses.
- Repository returning source-specific maps to the UI.
- Provider importing widgets or BLoC state.
- Mapper performing network or storage calls.
- Model depending on presentation code.
