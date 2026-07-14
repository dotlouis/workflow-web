# Deploy and Host workflow-web on Railway

workflow-web is the observability dashboard of the [Vercel Workflow DevKit](https://useworkflow.dev) (`@workflow/web`), packaged for self-hosting. It reads workflow runs from a Postgres World (`@workflow/world-postgres`) and lets you browse runs, steps, events, and errors of your durable workflows — without deploying your app on Vercel.

## About Hosting workflow-web

The npm package ships a prebuilt Next.js standalone server, so hosting is a thin Dockerfile around `node node_modules/@workflow/web/server.js` (Node 24 — the dashboard uses `node:sqlite`). This template deploys the dashboard together with a Postgres database, pre-linked via `WORKFLOW_POSTGRES_URL=${{Postgres.DATABASE_URL}}`; if your workflow app already has a World database, repoint that one variable at it after deploying. The dashboard is a pure reader — it never starts a workflow worker, so it won't drain your queue. It listens on port `3456` and has **no built-in authentication**: keep it on Railway's private network (or behind a VPN/auth proxy) rather than adding a public domain.

## Common Use Cases

- Inspecting and debugging production workflow runs (steps, retries, failures) when your app runs the Postgres World on Railway instead of Vercel
- Giving your team visibility into workflow executions without handing out database credentials
- Watching a shared workflow database from multiple environments while your app's in-process worker keeps executing runs

## Dependencies for workflow-web Hosting

- A Postgres database holding the Workflow World schema — the bundled Postgres service, or an existing one written to by your app (`bun run workflow:seed` / `npx workflow setup` seeds the schema)
- An application using the Workflow DevKit (`workflow` + `@workflow/world-postgres`) that writes runs to that database

### Deployment Dependencies

- Source repo: https://github.com/dotlouis/workflow-web
- Workflow DevKit: https://useworkflow.dev and https://github.com/vercel/workflow
- npm packages: [`@workflow/web`](https://www.npmjs.com/package/@workflow/web), [`@workflow/world-postgres`](https://www.npmjs.com/package/@workflow/world-postgres)
- Private access over a tailnet (optional): https://github.com/dotlouis/tailscale-rw

### Implementation Details

Keep the dashboard's package versions in sync with the app that writes the World, to avoid schema drift — pins live in the wrapper's `package.json`:

```json
"dependencies": {
  "@workflow/web": "4.1.12",
  "@workflow/world-postgres": "4.2.0"
}
```

The dashboard is reachable over Railway private networking at `http://workflow-web.railway.internal:3456` from services in the same project (the server binds `::`, as Railway's private network is IPv6-only).

## Why Deploy workflow-web on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying workflow-web on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
