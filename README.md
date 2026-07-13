# workflow-web

Deployable wrapper for [`@workflow/web`](https://www.npmjs.com/package/@workflow/web) —
the observability dashboard of the [Vercel Workflow DevKit](https://github.com/vercel/workflow) —
reading workflow runs from a Postgres World
([`@workflow/world-postgres`](https://www.npmjs.com/package/@workflow/world-postgres)).

The upstream `vercel/workflow` repo is a source monorepo and not directly deployable;
the npm package ships a prebuilt Next.js standalone server, so this repo is just a
Dockerfile + a 2-dependency `package.json` around `node node_modules/@workflow/web/server.js`.

It is a **reader**: it does not start a worker, so it will not drain the workflow
queue — your app's in-process worker keeps executing runs.

## Deploy on Railway

Point a service at this repo (Dockerfile build) and set:

| Var | Value |
| --- | --- |
| `WORKFLOW_TARGET_WORLD` | `@workflow/world-postgres` |
| `WORKFLOW_POSTGRES_URL` | DSN of the Postgres World DB, e.g. `${{Postgres.DATABASE_URL}}` |
| `PORT` | `3456` (any port works) |

The container binds `::` (`HOSTNAME=::`), so it is reachable over Railway's
IPv6-only private network at `<service>.railway.internal:<PORT>` without a
public domain. Only add a public Railway domain if you want the dashboard on
the open internet (it has **no authentication** — prefer private networking, a
VPN/tailnet route such as [tailscale-rw](https://github.com/dotlouis/tailscale-rw),
or put an auth proxy in front).

## Version pinning

Pin `@workflow/web` / `@workflow/world-postgres` here to match the `workflow` /
`@workflow/world-postgres` versions used by the app that writes the World, so the
dashboard reads the World DB schema correctly.
