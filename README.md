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

## Getting Started

### With Docker (Recommended)

1.  **Prerequisites**: `docker` and `docker compose`.
2.  **Build and Run**: 
    ```bash
    docker compose up --build
    ```
3.  **Access**: http://localhost:3000

**Common Docker Commands**:
- **Rails Console**: `docker compose exec web rails c`
- **Run Migrations**: `docker compose exec web rails db:migrate`
- **Run Seeds**: `docker compose exec web rails db:seed`
- **Run Tests**: `docker compose exec web rails test`

### Local Installation

1.  **Prerequisites**: Ruby 3.3+, PostgreSQL, Node.js.
2.  **Setup**:
    ```bash
    bundle install
    rails db:create db:migrate db:seed
    ```
3.  **Run**:
    ```bash
    rails s
    ```
4.  **Access**: http://localhost:3000

**Common Local Commands**:
- **Rails Console**: `rails c`
- **Run Migrations**: `rails db:migrate`
- **Run Seeds**: `rails db:seed`
- **Run Tests**: `rails test`