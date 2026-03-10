## Python Programming Guide

### General Principles

- 복잡한 추상화보다 단순하고 명시적인 코드를 우선합니다.
- dependency injection을 항상 고려하고, 강한 결합을 피합니다.
- 각 layer나 object가 분명한 하나의 책임을 가지도록 고려 사항을 분리합니다.
- layer 사이의 reverse dependency를 방지합니다.
- 구현할 때는 사용자가 이해할 수 있도록 적절하게 comments를 추가합니다. 모든 줄에 comments를 달 필요는 없고, 의미 단위로 추가합니다.
- public functions, classes, modules에 대해서는 역할이나 contract를 더 분명하게 해줄 때 docstrings를 작성합니다.
- 과도하게 많은 helper functions를 만들지 않습니다. 필요한 의미 단위의 함수와 헬퍼 함수를 두었을 때, 가독성 올라가는 필수적인 경우 사용합니다. 

### Architecture

- domain/ (또는 이에 준하는 layer)는 순수한 domain model (entities/value objects)로 유지합니다.
- dataset/repository/ 는 data access와 shaping (raw row -> domain conversion)만 담당해야 합니다.
- adapters/clients/ 는 external system communication만 담당해야 하며, 내부 service/policy types에 의존하면 안 됩니다.
- service/usecases/ 는 application orchestration (workflow)을 담당하며, policy/rule evaluation과 result integration을 담당합니다.

### Dependency Injection and Composition Root

- core logic는 가능한 한 순수하게 유지합니다. I/O에 직접 의존하지 않고 입력을 받아 판단을 내려야 합니다.
- clients, Settings, external dependencies는 `create()` 같은 composition root에서 받아와서 객체를 생성하여 반환하는 헬퍼로 사용합니다.
- `__init__`에는 settings를 그대로 받기보다는 객체에서 꼭 필요한 값들을 분리하여 받습니다.
- low-level modules는 high-level service나 result types를 import하면 안 됩니다.
- time, randomness, clients, configuration이 determinism이나 testability에 영향을 주는 경우 injectable하게 만듭니다.

### Typing

- `None`과 optional values를 명시적으로 다뤄서 `mypy`가 잘못된 가정을 잡아낼 수 있게 합니다.
- data가 module이나 layer 경계를 넘을 때는 raw `dict`보다 typed models (`Pydantic`, `TypedDict`, dataclass)을 우선합니다.
- 단, 모든 값을 typed model로 넘길 경우, 코드가 복잡해질 수 있음으로, dicts 혹은 복잡한 출력이 동반되는 경우에만 사용합니다.
- 안정적인 domain states에는 magic strings 대신 `Enum` 또는 `Literal`을 사용합니다. 

### Error Handling

- error는 그 실패 문맥을 소유한 layer에서 처리합니다.
- inner layer가 이미 contract를 소유하고 있다면 outer layers에서 중복으로 error handling을 추가하지 않습니다.
- 조용히 복구하는 것보다 명시적인 exceptions, error raise와 failure messages를 사용합니다.
- broad exception handling은 보통 entrypoints, jobs, external adapters 같은 application boundary에만 두어야 합니다.

### Patching

- 시스템의 한 부분을 변경할 때는 관련된 flows와 dependent modules를 함께 검토한 뒤 변경을 마무리합니다.
- 인접한 flows가 같은 책임을 이미 어떻게 처리하고 있는지 확인하지 않은 채, 고립된 validations이나 abstractions를 추가하지 않습니다.
- 새로운 validation을 추가하기 전에, 그 invalid state가 실제로 도달 가능한지와 그 validation이 해당 layer의 책임인지 먼저 확인합니다.
- 변경이 기존 contracts에 영향을 줄 수 있다면, naming, comments, tests, type assumptions를 함께 갱신합니다.

### Style

- 가능하면 functions에서 raw `Dict` type을 직접 반환하지 않습니다. `TypedDict` 또는 `Pydantic` model을 사용합니다.
- 모든 것을 `Pydantic`이나 `TypedDict`로 만들 필요는 없지만, 실제로 필요한 경계에서는 이를 적극적으로 사용합니다.
- hard-coded strings 대신 `Enum` 또는 `Literal`을 사용합니다.
- variables, functions, classes 등의 이름은 목적이 드러나도록 명확하게 짓고, 같은 scope 안에서 중복되는 이름을 피합니다.
- forward references에는 quotes보다 `__future__ annotations`를 우선합니다.
- 특별한 이유가 없다면 functions나 classes 내부에서 import를 사용하지 않습니다.

### Settings and Configs

- `Settings`와 `Configs`라는 용어를 엄격하게 구분합니다.
  - `Settings`: environment/runtime (ENV, endpoint, token)
  - `Configs`: rule/policy parameters (business rule inputs provided via YAML)
- singleton으로 settings를 정의한 파일에 settings 객체를 선언하고 이를 같은 레이어에서 import하여 사용합니다. 
- singleton `Settings`를 사용하더라도, services와 policies는 가능하면 `create()` 또는 다른 composition root를 통해 wiring합니다.
- 팀에서 사용하는 패턴은 `from layer import BlahSettings, blah_settings` 를 하여, `create(settings:BlaSettings=None)` 같은 식으로 처리하고, `if not settings: settings=blah_settings`와 같이 처리합니다. 
- business logic modules 여러 곳에 direct settings access가 퍼지지 않도록 합니다.
- required keys, enum coverage, structural invariants는 settings/config boundary에서 검증합니다. 이후 검증이 완료되어서 추가적인 검증이 필요하지 않은 경우, 중복 검증하지 않습니다.

### Contracts and Validation

- invalid state가 upstream bug나 깨진 data contract를 숨기게 된다면, silent fallback보다 fail-fast behavior를 우선합니다.
- defaults는 실제 domain rule을 표현할 때만 사용하고, 누락되거나 잘못된 입력을 가리는 용도로 사용하지 않습니다.

### Tests and Lint

- 변경 후에는 flake8과 mypy (또는 이에 준하는 lint/type checkers)를 통과해야 합니다. (Poetry 사용 시: `poetry run flake8 . && poetry run mypy .`)
