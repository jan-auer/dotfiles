---
paths:
  - "**/*.rs"
---

# Rust Rules

## Safety

- No `.unwrap()` in non-test code without `// INVARIANT:` comment explaining why it cannot fail
- Every `unsafe` block needs a `// SAFETY:` comment

## Code Style

- No wildcard match arms (`_`) on project-owned enums — handle all variants explicitly
- No wildcard imports except test modules and designed preludes
- No complex expressions (chains, closures, async calls) in control flow positions (`match`, `if let`, `let else`, `for`) — extract into a named variable first
- When matching `Option`/`Result` only to early-return on one variant, prefer `let ... else` over `match`
- Conversion prefixes: `as_` (free, borrow→borrow), `to_` (expensive, borrow→owned), `into_` (owned→owned); no bare `from_` when `to_`/`into_` is more ergonomic
- Consistent word order across related names within a crate

## Maintenance

- When removing code, check if any crate dependencies became unused and remove them from `Cargo.toml`

## Documentation

- Doc comments (`///`) on every public item — summary line in third-person present indicative ("Returns the …", not "Return the …")
- Use `?` in doc examples, never `unwrap()`
- Write doc tests for public APIs (both published crates and cross-crate in workspaces) — they serve as both documentation and regression tests

## Type Design

- Newtypes for domain distinctions (e.g., `Miles(f64)` vs `Kilometers(f64)`) — compile-time unit safety
- Builder pattern for types with optional configuration or complex construction
- No out-parameters — return tuples or structs instead of mutating `&mut` params
- Struct fields private by default; expose via methods (adding a public field is a commitment)
- `Debug` on all public types
- No trait bounds on data structs unless required — adding one later is a breaking change
