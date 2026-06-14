# Architecture

The kit follows a pragmatic Flutter architecture:

UI / Page / Widget -> BLoC -> Repository -> Provider -> API / Local Storage -> Mapper -> Model

## Layers

### UI / Page / Widget

Owns layout, input, navigation triggers, and state rendering. UI reads BLoC state and dispatches events or method calls. It should not know how data is fetched, cached, parsed, or persisted.

### BLoC

Owns user-flow state. A BLoC coordinates repositories, handles loading and failure states, and exposes state that is easy for widgets to render.

### Repository

Owns data decisions for a feature. A repository can combine providers, choose local or remote data, and expose methods named after product behavior.

### Provider

Owns a concrete data source. Providers talk to APIs, local storage, platform services, secure storage, or databases. They return source-shaped data or DTO-like structures.

### API / Local Storage

Represents external boundaries. Keep these details isolated so schema and storage changes do not spread through the feature.

### Mapper

Owns conversion between external structures and app models. Mappers are the pressure valve for API changes.

### Model

Owns durable app data shape. Models should be simple to construct, compare, and use in tests.

## Dependency Rule

Dependencies point inward through the flow. Higher layers may depend on the next lower boundary, but lower layers should not import presentation code.
