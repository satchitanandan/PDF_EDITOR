\# DevOps Notes — PDF\_EDITOR



\## Assumptions

\- The app is TanStack Start (Vite + Nitro), built with Bun. `bun run build`

&#x20; produces `.output/server/index.mjs`, a Node/Bun-runnable server (Nitro's

&#x20; node-server preset) — I could not confirm the exact Nitro preset from the

&#x20; repo listing alone, so this assumes the default.

\- No real database is used by the app today (it's a client-side PDF editor

&#x20; using pdf-lib/pdfjs in the browser). Postgres is included in

&#x20; docker-compose only to satisfy the assessment's "runs alongside a

&#x20; database" requirement, not because the app currently needs one.

\- Container registry target is GHCR (`ghcr.io`), authenticated via the

&#x20; built-in `GITHUB\_TOKEN` — no external registry credentials needed.

\- Deploy step is simulated (`kubectl set image ...` echoed, not executed)

&#x20; since there's no real cluster/target for this exercise.



\## Trade-offs

\- Used a two-stage Docker build (Bun for both build and runtime) to keep

&#x20; the image small and avoid a second runtime/toolchain; a slimmer

&#x20; `distroless` runtime would cut image size further but would drop `bun`,

&#x20; and Nitro's node-server output may still need a JS runtime present.

\- Healthcheck is a simple `/health` JSON route rather than full Prometheus

&#x20; metrics, to fit the 90–120 min time box — noted as the natural next step.

\- CI splits build/test from build/push/deploy so pull requests get fast

&#x20; feedback without needing registry credentials, and only `main` pushes

&#x20; trigger image publishing and deploy.

\- `depends\_on: condition: service\_healthy` in compose ensures the app

&#x20; doesn't start before Postgres is actually accepting connections, not

&#x20; just after the container process starts.

