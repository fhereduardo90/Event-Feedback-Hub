# Event Feedback Hub

A real-time web application for collecting and viewing event feedback with interactive features.

## Features

- **Interactive Feedback Form**: Submit feedback with event selection, star ratings (1-5), and text reviews
- **Real-time Stream**: View feedback from all users with live updates using WebSockets
- **Filtering & Pagination**: Filter by event or rating, paginated results
- **Responsive Design**: Clean, mobile-friendly interface built with Tailwind CSS

## Tech Stack

- **Rails 8** with Hotwire (Turbo + Stimulus)
- **PostgreSQL** for data persistence
- **ActionCable** for real-time WebSocket updates
- **Tailwind CSS** for styling
- **Minitest** with comprehensive test coverage

## Setup

1. **Install dependencies**
   ```bash
   bundle install
   ```

2. **Setup database**
   ```bash
   rails db:create db:migrate db:seed
   ```

3. **Start the server**
   ```bash
   rails server
   ```

4. **Visit the application**
   ```
   http://localhost:3000
   ```

## Testing

Run the complete test suite:
```bash
rails test
```

## Requirements

- Ruby 3.3+
- PostgreSQL
- Node.js (for asset compilation)
