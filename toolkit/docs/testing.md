# Testing

Testing should protect behavior and architecture without making refactors painful.

## Recommended Coverage

- BLoC: state transitions for success, empty, and failure.
- Repository: source selection and error translation.
- Mapper: schema conversion and missing-field handling.
- Widget: critical rendering and user intent dispatch.

## Test Style

- Prefer deterministic fake providers over live services.
- Assert meaningful state, not private implementation detail.
- Keep fixture data small and named after the scenario.
- Avoid broad snapshots unless the UI is intentionally stable.

## Minimum Bar

For new features, cover the main happy path and one failure path. For bug fixes, add a regression test at the layer where the bug belongs.
