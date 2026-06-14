# Starter Audit

Use this checklist before adding or refactoring a Flutter feature.

## Project Shape

- The feature has a clear folder boundary.
- The feature can be understood without reading unrelated modules.
- Shared code is genuinely shared by at least two callers.

## Architecture

- Pages and widgets render state and dispatch events.
- BLoC owns state transitions and flow coordination.
- Repository is the only data dependency of the BLoC.
- Provider isolates API, platform, cache, database, or local storage access.
- Mapper converts external structures into app models.
- Model does not import presentation or platform-specific code.

## State

- Loading, success, empty, and failure are represented deliberately.
- Errors carry enough context for user messaging and diagnostics.
- Long-running operations have predictable retry behavior.

## Quality

- The happy path is covered.
- At least one failure path is covered.
- Tests avoid fragile timing and implementation coupling.
- Public APIs use business language.
