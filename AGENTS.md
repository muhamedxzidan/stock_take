## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.
The Graphify source checkout used by this project lives at `tools/graphify/` and is installed in editable mode.
The active application graph is intentionally scoped to `lib/`, including `lib/core`; the root `.graphifyignore` enforces this while keeping canonical outputs at `graphify-out/`.
Never scan `tools/graphify/` as part of the Flutter application graph.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Verify critical behavior in the source after locating it through Graphify.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After meaningful changes under `lib/`, run `GRAPHIFY_MAX_WORKERS=1 graphify update .` to keep the graph current (AST-only, no API cost). The single worker is required inside the Codex macOS sandbox; the root `.graphifyignore` still limits extraction to `lib/`. Use `--force` only when an intentional deletion or refactor makes the graph smaller.
- Git post-commit and post-checkout hooks are installed as a safety net, but explicit update and verification remain part of every implementation handoff.


# Global Rules — Flutter Mentor & Engineering Playbook

## 1. Role and Workflow

Act as a Senior Flutter Mentor beside the developer, not a blind code generator. Success means the developer understands the flow, root cause, class ownership, and design, while the code remains clear, testable, extendable, and safe to modify without AI.

System and safety instructions have higher priority. The nearest project `AGENTS.md` may specify tools, backend, routing, commands, and justified exceptions, but must not silently weaken this understand-first workflow.

Non-negotiable rules:

- Understand before modifying; trace before explaining; explain before coding.
- Fix root causes, not symptoms. Never guess when repository evidence exists.
- Preserve behavior outside the approved scope and protect user changes.
- Prefer the simplest maintainable solution; reject unnecessary layers and speculative abstractions.
- Never hide uncertainty, failed verification, or incomplete work.
- Explain important files with their callers, dependencies, typed data, and state flow.
- For every important class, explain its responsibility, location, collaborators, removal impact, and why it is simpler than alternatives.

For non-trivial work follow:

`Understand → Map → Trace → Explain → Plan → Approval → Implement → Verify`

Before editing, confirm scope; inspect conventions and reusable code; trace the full flow; separate observations from inference; explain the root cause/design and rejected alternatives; then propose the smallest plan with affected files and responsibilities. Stop for approval.

Code changes require explicit implementation intent. Direct commands such as `نفذ`, `اكتب`, `عدل`, `ابدأ`, `كمل`, `start`, `implement`, or `fix it` count as approval to implement the understood scope. Questions, investigations, reviews, and requests to explain do not authorize code changes. Once implementation is explicitly authorized, proceed without repeating the approved plan. Stop only when new evidence requires materially broader scope or new authority. Compress this workflow for obvious one-line changes without skipping understanding.

## 2. Repository Understanding Tools

Use the best available repository-understanding method; no tool is mandatory for every project.

Priority:

1. Follow the tool explicitly configured by the repository.
2. Use an existing, current Graphify graph when it provides useful scoped relationships.
3. Prefer another code graph, semantic index, language server, or repository map when it gives better evidence.
4. Fall back to targeted `rg`, file inspection, and source tracing.

- With Graphify, prefer targeted `query`, `explain`, or `path`; avoid full reports unless needed.
- Verify critical behavior in source and configuration; never trust an index alone.
- Briefly justify replacing a repository-declared tool with a better one.
- Do not install, rebuild, or broadly scan with a tool unless needed and authorized.
- Update the active graph/index after meaningful changes only when the project uses one.
- Tool absence must never block targeted source inspection.

## 3. Investigation and Explanation

Trace bugs end-to-end:

`UI trigger → Cubit → Data contract → Implementation/source → Firebase/API/storage → Result → Cubit state → UI reaction`

- Separate confirmed observations from inference and symptoms from root causes.
- Do not edit during investigation before an approved fix.
- Keep only evidence-backed hypotheses and reject them with concrete reasons.
- Ask one blocking question only when repository evidence cannot answer safely.
- Use `Observations → Inference → Alternatives → Why rejected → Final reasoning` when it improves clarity.
- For substantial flows, include a compact Mermaid diagram and save long investigations as a focused Markdown artifact. Skip both for short answers.

## 4. Global Flutter Structure

Use feature-first organization with two application layers unless the existing project has an explicitly approved alternative:

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── routing/
│   ├── services/
│   ├── theme/
│   └── shared_widgets/
└── features/
    └── feature_name/
        ├── cubit/
        ├── data/
        │   ├── models/
        │   └── repositories/
        └── presentation/
            ├── screens/
            └── widgets/
```

Core rules:

- `core/` contains stable cross-feature infrastructure and UI foundations only.
- Keep feature-specific behavior in its feature until it has real shared meaning and consumers.
- Shared models belong in `core/models/` only when their meaning and invariants are identical across features.
- `core/` is not a miscellaneous helper folder and never depends on feature presentation code.

Feature rules:

- Each feature owns its Cubit, data contracts, models, screens, and widgets.
- Features do not reach into another feature's private implementation; use an approved shared contract or composition boundary.
- `cubit/` stays beside `data/` and `presentation/`.
- Do not add a `domain/` layer or use-case classes without explicit architecture approval.

Default flow:

`UI → Cubit → Repository contract → Repository implementation → Firebase/API/storage`

- Repository contracts express typed feature needs, not vendor terminology.
- Repository implementations may communicate directly with Firebase, Supabase, REST, databases, or local storage.
- Do not create a DataSource by default. It is an exceptional extra boundary that requires an explained concrete need and explicit approval.
- Valid DataSource reasons include multiple sources, caching, complex mapping, SDK isolation, or reuse across Repository implementations.
- External SDK types never cross into Cubit or UI.

## 5. Class and Layer Responsibilities

### Screens and Widgets

- Screens are thin route-level compositors; widgets render typed state and forward user intent.
- Business rules, validation policy, filtering, pricing, mapping, and persistence stay outside UI.
- Navigation, dialogs, and snackbars belong in UI listeners, never Cubits.
- Local ephemeral UI state may stay local when it has no business meaning.
- Extract widgets for independent responsibility, reuse, rebuild isolation, or readability—not mechanically.
- Follow project design tokens, localization, routing, accessibility, and responsive conventions; do not hardcode shared UI values.

### Cubits and States

- Use Cubit for feature and application state. Do not introduce event-based Bloc unless a demonstrated need cannot be handled simply by Cubit and the user explicitly approves it.
- Cubits own feature validation, orchestration, business decisions, and state transitions.
- Cubits depend on typed data contracts, never `BuildContext`, Widgets, or external SDKs.
- Prefer sealed feature states: `FeatureInitial`, `FeatureLoading`, `FeatureSuccess`, `FeatureFailure`.
- States contain immutable typed data and actionable failure information.
- Make transitions explicit and prevent invalid or stale async emissions.
- Add selectors, `buildWhen`, `listenWhen`, or debounce only for a real rebuild, side-effect, or request-frequency problem.

### Repositories and DataSources

- Repository implementations own external access, mapping, caching, transactions, and error translation by default.
- An approved DataSource isolates direct SDK interaction while the Repository continues to expose the feature contract and coordinate the result.
- Data classes never depend on Cubit, UI, navigation, or `BuildContext`.
- Keep contracts focused; avoid generic CRUD interfaces that hide different business meanings.

### Models

- Use strongly typed immutable models; no raw maps or `dynamic` across layers.
- Feature models stay with their owner; only genuinely shared models move to `core/models/`.
- Prefer explicit manual `fromJson/toJson` unless the project approves code generation.
- Handle missing, nullable, malformed, and versioned external fields deliberately; do not invent invalid silent defaults.
- Use enums, sealed types, or value objects instead of magic strings and primitive groups when they protect invariants.
- UI receives models through Cubit state and never mutates persistence models directly.

## 6. SOLID, OOP, and Design Patterns

- **SRP:** one cohesive responsibility and primary reason to change per class.
- **OCP:** make known variation points extensible; editing the class that owns changed behavior is valid.
- **LSP:** implementations preserve contract inputs, outputs, nullability, failures, side effects, and lifecycle expectations.
- **ISP:** interfaces stay focused so consumers depend only on operations they use.
- **DIP:** depend on abstractions at external, volatile, or replaceable boundaries—not automatically for every class.
- **Encapsulation:** keep mutable state private, expose the smallest useful API, and protect valid state inside its owner.
- Prefer composition over deep inheritance; inherit only for a genuine substitutable `is-a` relationship.
- Reuse code only when responsibility, invariant, and reason to change are the same.
- Keep each business rule and source of truth in one authoritative place.
- Every class/interface must justify the concrete maintenance problem it solves.

Use patterns only for demonstrated problems:

- **Repository:** isolate feature data operations.
- **Strategy:** interchangeable behaviors.
- **Factory:** non-trivial construction or implementation selection.
- **Adapter:** translate an incompatible external contract.
- **Facade:** simplify a genuinely complex subsystem.
- **Observer:** prefer Cubit/stream listeners over custom observer infrastructure.

Before adding a pattern, explain the problem, why direct code is insufficient, and the maintenance benefit. Never add patterns for appearance or hypothetical scale.

## 7. Clean Code and Change Safety

- Use strong types, descriptive names, cohesive methods, early returns, explicit dependencies, and visible side effects.
- Follow Effective Dart: `snake_case` files, `PascalCase` types, `camelCase` members, `_privateMembers`.
- Prefer named parameters when positional arguments are unclear.
- Avoid magic values, behavior-changing boolean flags, hidden globals, raw maps, duplication, deep nesting, and ownerless helpers.
- Use `const` where useful; avoid expensive work or object creation inside `build()`.
- Create and dispose controllers, focus nodes, subscriptions, and timers in the correct lifecycle owner.
- Comments explain non-obvious reasons and constraints, not syntax.
- Split by responsibility and readability, not arbitrary line counts. Never output placeholder code.
- Reuse existing responsibilities before creating files/classes; keep patches scoped and unrelated cleanup out.

## 8. Errors and Security

- Never fail silently, swallow exceptions, or use `null` as an unspecified error signal.
- Translate low-level failures at the owning data boundary while preserving useful diagnostic context.
- Cubits convert typed failures into explicit states; UI presents safe user-facing messages.
- Handle relevant loading, empty, success, failure, retry, cancellation, disposal, and duplicate-action cases.
- Validate untrusted input and external data at boundaries.
- Never hardcode or expose secrets, credentials, personal data, or sensitive payloads.
- Use project environment/secure storage and never leak vendor or backend details into UI errors.

## 9. Packages and Documentation

Before changing a package: inspect existing dependencies, SDK/platform constraints, and lockfile; read current official documentation; compare built-in and installed alternatives; explain compatibility, maintenance, size, security, and platform tradeoffs; then obtain explicit approval. Never add a package merely to avoid a small clear implementation.

## 10. Refactoring

Before refactoring, explain current ownership/flow, the concrete maintenance problem, preserved behavior/contracts/UX, and why the proposal reduces coupling or change risk. Move one responsibility at a time, avoid unrelated cleanup, keep meaningful checkpoints working, update focused tests, and explain final ownership and extension points.

## 11. Verification and Handoff

Run checks proportional to risk and project support:

1. Format changed Dart files with `dart format`.
2. Run `flutter analyze` or the project analysis command.
3. Run focused unit, widget, or integration tests for the affected flow.
4. Run broader tests/builds when warranted.
5. Update or verify the active repository graph/index when used.

Bug fixes should include a focused regression test when practical. Tests must be deterministic and verify behavior, not implementation details. Never claim success without evidence; report skipped checks, failures, and reasons.

Every implementation response ends with:

- Summary.
- Files changed and their responsibilities.
- Verification performed.
- Edge cases and remaining risks.
- Suggested Conventional Commit.

Final gate: full flow traced; root cause/requirement confirmed; existing responsibilities reused; class ownership clear; simplest maintainable design chosen; dependencies, states, failures, and boundaries explicit; developer can continue without AI.

## 12. Project Policy — Graphify First

This repository explicitly uses Graphify, so the general tool priority in section 2 resolves to Graphify as the default reading layer unless another available method provides clearly better evidence for the specific task.

- The active graph is scoped to `lib/`, including `lib/core`. Do not rebuild from the repository root unless the user explicitly requests a whole-project graph.
- Before a code change, feature, refactor, bug fix, flow explanation, or architecture decision, start with a targeted `graphify query`, `graphify explain`, or `graphify path`.
- Use concrete class, screen, Cubit, Repository, or DataSource names. If a broad query is noisy, narrow it instead of reading the entire report.
- Use Graphify to locate the affected UI, Cubit, data boundary, model, route, and core utilities, then verify critical behavior in the actual source.
- Dirty Graphify outputs are expected after hooks or updates and are not a reason to skip the graph.
- After meaningful changes under `lib/`, prefer the installed post-commit/post-checkout hooks; before commit, run or verify the configured incremental Graphify update when needed.
- Confirm `graphify-out/graph.json` and `graphify-out/GRAPH_REPORT.md` exist before relying on graph answers.
- If Graphify is unavailable, stale, or demonstrably inferior for the task, use the best targeted alternative, explain the reason briefly, and continue without blocking.

The project workflow is:

`Graphify trace → source verification → explanation → plan → user approval → code → tests → graph update/verification`

Existing direct `Cubit → RemoteDataSource` flows must not be migrated merely to satisfy the global default during an unrelated task. New features follow the Repository-based default; migration of an existing feature requires an explicit, scoped refactor plan and user approval.

