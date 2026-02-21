## Design Architecture

### General Rule

- Keep minding dependency injection. Avoid tight coupling.
- Always think about the modularity and separation of concerns.
- Prefer layered architecture. Do not put all logic in a single layer.
- 역방향 dependency가 발생하지 않도록 주의한다.
- 구현을 진행할 때, 사용자가 이해할 수 있도록 주석을 적절하게 표시한다. 모든 라인에 할 필요는 없으며, 의미단위로 주석을 추가한다.
- 함수를 구현할 때에 그 함수가 최소한 무슨 역할을 하는지 한줄은 적어둔다.

### Architecture

- domain/(또는 이에 준하는 레이어)은 순수 도메인 모델(entities/value objects)로 유지한다.
- dataset/repository/는 data access + shaping 역할만 가진다(raw row → domain 변환).
- adapters/clients/는 외부 시스템 통신만 담당하고, 내부 서비스/정책 타입에 의존하지 않는다.
- service/usecases/는 애플리케이션 오케스트레이션(workflow)이며, 정책/룰 평가 및 결과 통합을 담당한다.

### DI / Composition Rule

- 코어 로직은 입력을 받고 결정을 내리는 순수 함수/객체로 유지.
- 시간/랜덤/클라이언트/설정 로더는 주입 가능하게 만들어 테스트를 안정화.

### Typing

- mypy가 잡아줄 수 있도록 None/optional을 명시적으로 다룬다.
- 불필요한 래퍼/프로퍼티는 제거하고 표준 API를 직접 사용

### Error Handling

- 에러 핸들링은 의미상 같은 객체/함수 내부에서 하고, 그 외부에서 이중으로 에러 핸들링을 넣지 않도록 합니다.

### Patching

- 수정할 때, 해당 수정으로 다른 부분이 영향을 받을 수 있다면 해당 부분까지 고려하여 수정을 진행해야 합니다.
- 새로운 기능을 고안하거나 구상할 때, 혹은 아키텍쳐를 설계할 때, 너무 하나에 매몰되지 말고, 다른 기능까지 문제가 없는지 고려하여 설계를 해야합니다. 어떤 부분까지 고려해야할지 모르겠다면 고려할 범위를 사용자에게 다시 물어보세요.
- 만약에 사용자가

### Style

- Do not return raw `Dict` type from functions if possible. Use `TypedDict` or `Pydantic` model instead.
- 너무 모든걸 pydantic이나 typeddict로 만들 필요는 없고, 꼭 필요한 부분에는 최대한 Pydantic, typeddict를 사용
- Rather than using hard-coded strings, use `Enum` or `Literal`
- When naming variables, functions, classes, etc., use descriptive names that convey their purpose. And avoid use duplicated names in the same scope.
- Prefer `__future__ annotations` then quotes for forward references.
- Do not use the import statement inside functions or classes unless necessary.

### Configs

- Settings vs Configs는 용어를 엄격히 구분한다.
  - Settings: 환경/런타임(ENV, endpoint, token)
  - Configs: 룰/정책 파라미터(YAML로 제공되는 business rule inputs)
- 변경 후 flake8 및 mypy(또는 동급의 lint/type checker)를 통과한다. (Poetry 사용 시: poetry run flake8 . && poetry run mypy .)
