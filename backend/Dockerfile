# Gurtu API: https://iqoo.yadvin.tech
#
# Secrets are never baked into the image: MONGODB_URI and the Firebase
# service account come from environment variables (set in Dokploy).

FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

FROM node:22-alpine
ENV NODE_ENV=production \
    PORT=4000
WORKDIR /app
# tini forwards SIGTERM so redeploys shut down cleanly (cron stopped,
# connections closed).
RUN apk add --no-cache tini
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./
COPY src ./src
USER node
EXPOSE 4000
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://127.0.0.1:4000/health > /dev/null || exit 1
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "src/index.js"]
