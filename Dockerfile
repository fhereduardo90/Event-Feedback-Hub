# Use latest Ruby 3.3 Alpine for security updates
FROM ruby:3.3-alpine3.20 AS base

# Install system dependencies with security updates
RUN apk update && apk upgrade --no-cache && apk add --no-cache \
  build-base \
  postgresql-client \
  postgresql-dev \
  yaml-dev \
  git \
  tzdata \
  && apk upgrade --available \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /app

# Development stage
FROM base AS development

# Copy Gemfile and install gems first (for better caching)
COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1 \
  && bundle config --global gem.no_document 1 \
  && bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Create a non-root user for security
RUN addgroup -g 1000 -S railsuser \
    && adduser -u 1000 -S railsuser -G railsuser \
    && chown -R railsuser:railsuser /app

USER railsuser

# Expose port 3000
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["./docker-entrypoint.sh"]

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]

# Production stage
FROM base AS production

# Set production environment variables
ENV RAILS_ENV=production
ENV NODE_ENV=production

# Copy Gemfile and install production gems only
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' \
  && bundle config --global frozen 1 \
  && bundle config --global gem.no_document 1 \
  && bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Precompile assets (with temporary SECRET_KEY_BASE for compilation only)
RUN SECRET_KEY_BASE=dummy_key_for_precompilation bundle exec rails assets:precompile \
  && SECRET_KEY_BASE=dummy_key_for_precompilation bundle exec rails tailwindcss:build

# Clean up build artifacts
RUN bundle clean --force \
  && apk del build-base git \
  && rm -rf ~/.bundle /tmp/* /var/tmp/* \
  && rm -rf /var/cache/apk/*

# Create a non-root user for security
RUN addgroup -g 1000 -S railsuser \
    && adduser -u 1000 -S railsuser -G railsuser \
    && chown -R railsuser:railsuser /app

USER railsuser

# Expose port 3000
EXPOSE 3000

# Production doesn't need the setup entrypoint
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]