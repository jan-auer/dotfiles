---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript Rules

- Never use `any` — use `unknown` + type guards, generics, or `satisfies`
- Never use `as` type assertions except at serialization boundaries — prefer type guards or `satisfies`
- No `// @ts-ignore` or `// @ts-expect-error` without a linked issue or explanation
- Branded/opaque types for domain identifiers (UserId, OrderId)
- Discriminated union return types for expected failures, not thrown exceptions
- Named exports over default exports
- `import type` for type-only imports
- Minimize `useEffect` in React — prefer derived state
