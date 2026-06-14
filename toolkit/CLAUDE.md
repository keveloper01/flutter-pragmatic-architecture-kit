# Claude Guidance

Use this repository as a Flutter-first codebase. Respect the architecture:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

Before changing code:

- Identify the feature boundary.
- Locate the BLoC, repository, provider, mapper, and model involved.
- Preserve existing naming and folder conventions.
- Keep generated or mechanical changes separate from design decisions.

When implementing:

- Put user interaction and rendering in pages or widgets.
- Put state transitions in BLoC classes.
- Put data orchestration in repositories.
- Put source-specific calls in providers.
- Put conversion logic in mappers.
- Put durable data shape in models.

When reviewing:

- Check for layer leaks.
- Check failure states and async cancellation assumptions.
- Check that tests describe behavior rather than implementation details.
