# @workflow/web — observability dashboard for Vercel Workflow DevKit runs
# stored in a Postgres World (@workflow/world-postgres).
#
# Node (not bun): @workflow/web is a Node app and imports `node:sqlite`, which
# bun does not implement. Node 24 has node:sqlite stable.
FROM node:24-bookworm-slim

WORKDIR /app

# Install only the published dashboard + Postgres World packages — the npm
# package ships a prebuilt Next standalone server, so there is no build step.
COPY package.json ./
RUN npm install --omit=dev

# Bind IPv6 as well: Railway private networking is IPv6-only, so the default
# 0.0.0.0 bind would be unreachable at <service>.railway.internal.
ENV HOSTNAME=::

CMD ["node", "node_modules/@workflow/web/server.js"]
