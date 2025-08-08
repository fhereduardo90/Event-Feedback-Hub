# Use Ruby 3.3 Alpine for lightweight but full compatibility
FROM ruby:3.3-alpine as base

# Install system dependencies required for Rails and gems
RUN apk add --no-cache \
    build-base \
    postgresql-client \
    postgresql-dev \
    yaml-dev \
    nodejs \
    npm \
    git \
    tzdata \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /app


# Copy Gemfile and install gems first (for better caching)
COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1 \
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