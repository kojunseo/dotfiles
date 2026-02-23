## Design Architecture

### General Rule

- Keep minding dependency injection. Avoid tight coupling.
- Always think about the modularity and separation of concerns.
- Prefer layered architecture. Do not put all logic in a single layer.
- Be careful to prevent reverse dependencies from occurring.
- When implementing, add comments appropriately so the user can understand. You do not need to comment every line; add comments by semantic unit.
- When implementing a function, write at least one line describing what role the function plays.

### Architecture

- domain/ (or an equivalent layer) should be kept as a pure domain model (entities/value objects).
- dataset/repository/ should only handle data access + shaping (raw row -> domain conversion).
- adapters/clients/ should handle only external system communication and must not depend on internal service/policy types.
- service/usecases/ are application orchestration (workflow) and are responsible for policy/rule evaluation and result integration.

### DI / Composition Rule

- Keep core logic as pure functions/objects that take input and make decisions.
- Make time/random/client/config loaders injectable to stabilize tests.

### Typing

- Handle None/optional explicitly so mypy can catch issues.
- Remove unnecessary wrappers/properties and use standard APIs directly.

### Error Handling

- Do error handling within the same object/function semantically, and avoid adding duplicate error handling outside it.

### Patching

- When making changes, if the modification can affect other parts, proceed with the change while considering those parts as well.
- When devising or planning new features, or when designing architecture, do not get too fixated on one thing; design while considering whether other features are also unaffected. If you are unsure how far to consider, ask the user again about the scope to consider.
- When planning to add validation, first review the existing code flow and related paths to avoid isolated decisions.
- For duplicate validations or validations for errors that are not reachable in the actual flow, do not add them by default; explicitly ask the user whether the validation is needed, and explicitly ask about the risks of adding it versus not adding it.
- If the user

### Style

- Do not return raw `Dict` type from functions if possible. Use `TypedDict` or `Pydantic` model instead.
- You do not need to make everything with Pydantic or TypedDict; for parts that are truly necessary, use Pydantic and TypedDict as much as possible.
- Rather than using hard-coded strings, use `Enum` or `Literal`
- When naming variables, functions, classes, etc., use descriptive names that convey their purpose. And avoid use duplicated names in the same scope.
- Prefer `__future__ annotations` then quotes for forward references.
- Do not use the import statement inside functions or classes unless necessary.

### Configs

- Strictly distinguish the terms Settings vs Configs.
  - Settings: environment/runtime (ENV, endpoint, token)
  - Configs: rule/policy parameters (business rule inputs provided via YAML)
- After changes, pass flake8 and mypy (or equivalent lint/type checkers). (When using Poetry: poetry run flake8 . && poetry run mypy .)
