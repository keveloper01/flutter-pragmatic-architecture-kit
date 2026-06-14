# Feature Workflow

Use this workflow when adding a Flutter feature.

1. Define the user outcome.
2. Sketch the state shape: loading, data, empty, failure.
3. Define the model before writing UI.
4. Create provider methods for source-specific access.
5. Add mapper functions for source-to-model conversion.
6. Add repository methods using business language.
7. Add BLoC state transitions.
8. Build the page and widgets against BLoC state.
9. Add tests for the happy path and one failure path.
10. Run analysis and relevant tests.

Keep each commit or work slice reviewable. A feature is easier to fix when each layer has one reason to change.
