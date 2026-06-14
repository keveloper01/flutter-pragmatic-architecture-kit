# Naming

Use names that describe product behavior and architectural role.

## Files

- `*_page.dart` for routed screens.
- `*_widget.dart` for reusable presentation pieces.
- `*_bloc.dart`, `*_event.dart`, and `*_state.dart` for BLoC.
- `*_repository.dart` for feature data orchestration.
- `*_provider.dart` for concrete data sources.
- `*_mapper.dart` for conversion logic.
- `*_model.dart` for durable app data.

## Classes

- Pages: `ProfilePage`
- Widgets: `ProfileHeaderWidget`
- BLoC: `ProfileBloc`
- Repository: `ProfileRepository`
- Provider: `ProfileRemoteProvider`
- Mapper: `ProfileMapper`
- Model: `ProfileModel`

Avoid names that only describe mechanics, such as `Manager`, `Helper`, or `Util`, unless the responsibility is genuinely generic and stable.
