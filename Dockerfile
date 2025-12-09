FROM oven/bun:1 AS base

FROM base AS dependencies
WORKDIR /app

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

FROM base AS builder
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

RUN bun run build

FROM nginx:alpine AS runner

COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80