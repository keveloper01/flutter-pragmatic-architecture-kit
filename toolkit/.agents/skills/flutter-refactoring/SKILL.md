# Flutter Refactoring Skill

Use this skill when improving structure while preserving behavior.

## Approach

1. Name the behavior that must remain unchanged.
2. Locate tests or add a small safety test.
3. Move responsibilities toward the correct layer.
4. Remove duplication only when the replacement is clearer.
5. Run analysis and relevant tests.

## Common Moves

- Extract a widget from a large page.
- Move parsing from BLoC to mapper.
- Move source calls from repository helper code into a provider.
- Rename generic methods into product language.
- Split broad state into explicit states.
