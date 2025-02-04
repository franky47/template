ARG NODE_VERSION=16-alpine3.16

# Install dependencies only when needed
FROM node:$NODE_VERSION AS prepare
RUN apk add --no-cache libc6-compat=1.2.3-r2
WORKDIR /app
COPY package.json yarn.lock ./

# Keep yarn install cache when bumping version and dependencies still the sames
RUN node -e " \
  const package = JSON.parse(fs.readFileSync('/app/package.json')); \
  const packageZero = { ...package, version: '0.0.0' };  \
  fs.writeFileSync('/app/package.json', JSON.stringify(packageZero));"

FROM node:$NODE_VERSION as deps
WORKDIR /app
COPY --from=prepare /app/package.json /app/yarn.lock ./
RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:$NODE_VERSION AS builder

ARG PRODUCTION
ENV PRODUCTION $PRODUCTION
ARG GITHUB_SHA
ENV GITHUB_SHA $GITHUB_SHA
ARG NEXT_PUBLIC_SITE_URL
ENV NEXT_PUBLIC_SITE_URL $NEXT_PUBLIC_SITE_URL

ENV NODE_ENV production
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN if [ -z "$PRODUCTION" ]; then \
  echo "Overriding .env for staging"; \
  cp .env.staging .env.production; \
  fi && \
  yarn build:export 

# Production image, copy all the files and run next
FROM ghcr.io/socialgouv/docker/nginx:7.3.1 AS runner

COPY --from=builder /app/out /usr/share/nginx/html

# Disable nextjs telemetry
ENV NEXT_TELEMETRY_DISABLED 1
