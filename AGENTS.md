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
