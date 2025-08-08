#!/bin/sh
set -e

echo "🐳 Starting Event Feedback Hub setup..."

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

# Precompile assets for Tailwind CSS
echo "🎨 Compiling Tailwind CSS..."
rails tailwindcss:build

echo "🚀 Starting Rails server..."

# Execute the main command
exec "$@"