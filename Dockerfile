# ---- Build stage ----
FROM oven/bun:1.2-alpine AS build
WORKDIR /app

COPY package.json bun.lock ./
RUN bun install

COPY . .
RUN bun run build

# ---- Runtime stage ----
FROM oven/bun:1.2-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000

# Non-root user for security
RUN addgroup -S app && adduser -S app -G app
COPY --from=build --chown=app:app /app/.output ./.output
USER app

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1

CMD ["bun", "run", ".output/server/index.mjs"]