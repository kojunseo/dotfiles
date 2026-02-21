## Design Architecture

### General Rule

- Keep minding dependency injection. Avoid tight coupling.
- Always think about the modularity and separation of concerns.
- Prefer layered architecture. Do not put all logic in a single layer.
- 역방향 dependency가 발생하지 않도록 주의한다.
- 구현을 진행할 때, 사용자가 이해할 수 있도록 주석을 적절하게 표시한다. 모든 라인에 할 필요는 없으며, 의미단위로 주석을 추가한다.
- 함수를 구현할 때에 그 함수가 최소한 무슨 역할을 하는지 한줄은 적어둔다.

### Style

- 불필요한 래퍼/프로퍼티는 제거하고 표준 API를 직접 사용
- 하드코딩된 값을 최대한 사용하지 않도록 하며, 필요한 경우 상단에 상수처럼 몰아두고 사용함
-

### Patching

- 수정할 때, 해당 수정으로 다른 부분이 영향을 받을 수 있다면 해당 부분까지 고려하여 수정을 진행해야 합니다.
- 새로운 기능을 고안하거나 구상할 때, 혹은 아키텍쳐를 설계할 때, 너무 하나에 매몰되지 말고, 다른 기능까지 문제가 없는지 고려하여 설계를 해야합니다. 어떤 부분까지 고려해야할지 모르겠다면 고려할 범위를 사용자에게 다시 물어보세요.
-
