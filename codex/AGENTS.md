## AGENTS.md

### General

- When searching files using `rg`, `grep` and etc., always exclude `.env` files by options like `--glob '!.env'`
- Critical Thinking. Do not flattering.
- The code quality should be for production level.

### Engineering Principles

- Do not preserve backward compatibility. Remove obsolete paths instead of adding compatibility layers, fallbacks, or migrations.
- Choose the simplest implementation that fully meets the current requirements. Avoid speculative abstractions, configuration, and indirection.
- Grow the system in layers. Start from the smallest version that works end to end, and add each new capability on top of a product that already works. Never trade a working product for unfinished complexity.
- Keep components modular and concerns clearly separated.
- Prefer established, well-maintained libraries when they reduce overall complexity or improve reliability. Do not reimplement common functionality without a clear reason.
- Lean on the dependencies already in the project before writing your own implementation or adding packages. Do not assume a library lacks a capability without checking its documentation and types.
- Make architectural decisions for the long term. Do not accept a stopgap that only works for now and is meant to be replaced later.

### Base

- `~/.codex/docs/` 하단에 상황에 맞는 지침이 있음으로, 아래의 내용을 보고 적절한 지침을 읽어서 따라야 함.
- 현재 사용자의 의도에 맞는 적절한 지침을 읽어야 하며, 필요한 경우에는 2개 이상의 지침을 읽어도 됨.

### Docs

#### programming.md

- 코드를 수정하거나 새로 구성할 때, 고려해야하는 기본적인 내용.

#### python-programming.md

- 파이썬 코드를 작업할 때, 확인해야하는 부분으로, 만약 파이썬 작업이라고 한다면 `programming.md` 말고 이 파일만을 확인.

#### query-work.md

- 사용자의 요청으로 쿼리를 직접 날려야할 때, 쿼리를 만들고 작업하는 부분에 대해서 참고해야함.
