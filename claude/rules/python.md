# Python Rules

- Type hints on all function signatures
- No bare `except:` or `except Exception:` without re-raising — catch specific exceptions
- No mutable default arguments — use `None` and assign in function body
- No `Any` without justification — use `TypeVar`, `Protocol`, or `Union`
- `logging` module over `print()` for operational output
- `pathlib.Path` over `os.path`
- `dataclasses` or `pydantic` for structured data, not bare dicts with string keys
- Modern type syntax: `list[str]`, `str | None` (not `List`, `Optional`)
- Prefer `ty` for type checking in new projects where its current coverage is sufficient; fall back to `mypy` or `pyright` when needed
