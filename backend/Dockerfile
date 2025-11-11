# Install dependencies only when needed
FROM registry.access.redhat.com/ubi9/nodejs-20 AS deps

WORKDIR /app
COPY package.json yarn.lock ./

RUN npm install -g yarn
RUN yarn install --frozen-lockfile

# If using npm with a `package-lock.json` comment out above and use below instead
# COPY package.json package-lock.json ./
# RUN npm ci

# Rebuild the source code only when needed
FROM registry.access.redhat.com/ubi9/nodejs-20 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm install -g yarn
RUN yarn build

# Production image, copy all the files and run next
FROM registry.access.redhat.com/ubi9/nodejs-20 AS runner
# RUN apt-get update
# RUN apt-get install -y openssl
# RUN dnf install -y openssl && dnf clean all

WORKDIR /app

ENV NODE_ENV production

# RUN addgroup --system --gid 1001 nodejs
# RUN adduser --system --uid 1001 nodejs

# COPY --from=builder --chown=nodejs:nodejs /app/ ./
COPY --from=builder --chown=1001:0 /app/ ./

# Create directories that need to be writable and set group permissions
RUN mkdir -p /app/data/sessions /app/data/logs/error && \
    chgrp -R 0 /app/data && \
    chmod -R g=u /app/data

# USER nodejs

EXPOSE 3000
ENV PORT 3000

# RUN yarn run prisma:generate
# RUN yarn run prisma:migrate
CMD ["node", "./dist/server.js"]
