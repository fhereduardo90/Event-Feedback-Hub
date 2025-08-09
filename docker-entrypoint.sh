#!/bin/sh
set -e

echo "🐳 Starting Event Feedback Hub setup..."

# Check for new gem dependencies in development
if [ "$RAILS_ENV" != "production" ] && [ -f "Gemfile" ]; then
  echo "📦 Checking for new dependencies..."
  if ! bundle check > /dev/null 2>&1; then
    echo "🔄 Installing new gems..."
    bundle install --jobs 4 --retry 3
  fi
fi

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h postgres -p 5432 -U ${POSTGRES_USER:-postgres}; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done
echo "✅ PostgreSQL is ready!"

# Check if database is already set up (check if events table exists)
echo "🔍 Checking database status..."
if rails runner "Event.count" > /dev/null 2>&1; then
  echo "✅ Database already initialized - skipping setup"
else
  echo "🚀 First time setup - initializing database..."
  
  # Create database
  echo "📦 Creating database..."
  rails db:create
  
  # Run migrations
  echo "🔧 Running migrations..."
  rails db:migrate
  
  # Seed the database
  echo "🌱 Seeding database with sample data..."
  rails db:seed
  
  echo "✅ Database setup complete!"
fi

# Conditional asset compilation (only if files changed or in production)
if [ "$RAILS_ENV" = "production" ]; then
  echo "🎨 Compiling Tailwind CSS for production..."
  rails tailwindcss:build
elif [ ! -f "public/assets/.sprockets-manifest-*.json" ] || [ -n "$(find app/assets app/javascript -newer public/assets/.sprockets-manifest-*.json 2>/dev/null)" ]; then
  echo "🎨 Compiling Tailwind CSS (assets changed)..."
  rails tailwindcss:build
else
  echo "✅ Assets are up to date - skipping compilation"
fi

echo "🚀 Starting Rails server..."

# Execute the main command
exec "$@"