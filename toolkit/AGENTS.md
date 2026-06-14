# Flutter Pragmatic Architecture Kit

This project uses a pragmatic Flutter architecture centered on explicit boundaries, testable behavior, and readable delivery.

## Target Architecture

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Working Rules

- Keep UI declarative and thin. Pages and widgets render state and dispatch intent.
- Keep BLoCs focused on user flows, state transitions, and coordination.
- Keep repositories as the only public data boundary used by BLoCs.
- Keep providers close to data sources: network clients, platform APIs, cache, database, or secure storage.
- Keep mappers responsible for translating external data into internal models.
- Keep models stable, explicit, and free from UI concerns.
- Prefer small files with clear ownership over broad utility layers.
- Add tests around behavior before broad refactors.

## Definition of Done

- The feature follows the target architecture.
- The main happy path and one failure path are tested.
- Loading, empty, success, and error states are represented intentionally.
- No feature code reaches around its layer boundary.
- Public names communicate business intent, not implementation trivia.
