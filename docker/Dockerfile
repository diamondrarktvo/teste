FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

# Set working directory
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock ./
RUN yarn install


# Rebuild the source code only when needed
FROM base AS builder

# Set environment variables for build limits
ENV BUILD_CPU_LIMIT=4 \
    BUILD_MEMORY_LIMIT=2g

# Set working directory
WORKDIR /app

# Copy node_modules from the 'deps' stage
COPY --from=deps /app/node_modules ./node_modules

# Copy the entire application
COPY . .

# Copy sample environment variables file
COPY .env.sample .env

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
# ENV NEXT_TELEMETRY_DISABLED 1

# Set environment variables from build arguments
ARG NEXT_PUBLIC_SERVER_NAME
ARG NEXT_PUBLIC_BACKEND_URL
ARG NEXT_PUBLIC_BACKEND_URL_PAPI
ARG NEXT_PUBLIC_PAPI_AUTHENTIFICATION_KEY

ENV NEXT_PUBLIC_SERVER_NAME ${NEXT_PUBLIC_SERVER_NAME}
ENV NEXT_PUBLIC_BACKEND_URL ${NEXT_PUBLIC_BACKEND_URL}
ENV NEXT_PUBLIC_BACKEND_URL_PAPI ${NEXT_PUBLIC_BACKEND_URL_PAPI}
ENV NEXT_PUBLIC_PAPI_AUTHENTIFICATION_KEY ${NEXT_PUBLIC_PAPI_AUTHENTIFICATION_KEY}

# Build the application
RUN yarn build


# Production image, copy all the files and run next
FROM node:lts-alpine AS runner
WORKDIR /app

# Set environment variables
ENV NODE_ENV production

# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED 1

# Update apk packages
RUN apk upgrade --no-cache

# Create a system group and user for running the application
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy static assets from the 'builder' stage
COPY --from=builder /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Switch to non-root user
USER nextjs

# Expose port 3000
EXPOSE 3000

ENV PORT 3000
# set hostname to localhost
ENV HOSTNAME "0.0.0.0"

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
CMD ["node", "server.js"]