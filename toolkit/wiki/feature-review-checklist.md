# Feature Review Checklist

- The feature follows the target architecture.
- UI state is explicit and renderable.
- BLoC does not know transport or storage details.
- Repository methods use product language.
- Provider methods are source-specific and narrow.
- Mapper covers nullable or missing source fields intentionally.
- Model construction is straightforward in tests.
- Tests cover the main success path.
- Tests cover at least one failure path.
- Error messages are useful for users or diagnostics.
