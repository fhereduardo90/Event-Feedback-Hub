# Event Feedback Hub

A real-time web application for collecting and viewing event feedback with interactive features.

## Demo

[Watch a demo of the application in action](https://drive.google.com/file/d/1CD_1_wL2tp2a5hjen9HcRXJ56OJ2Wg-d/view?usp=sharing)

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

### Docker Development Environment (Recommended)

1.  **Prerequisites**: `docker` and `docker compose`.
2.  **Build and Run**: 
    ```bash
    docker compose up --build
    ```
3.  **Access**: http://localhost:3000

The development environment includes:
- ✅ Hot reloading with volume mounts
- ✅ Debug gems and development tools
- ✅ Automatic gem installation when Gemfile changes
- ✅ Smart asset compilation (only when files change)

**Essential Commands**:
- **Build & Run**: `docker compose up --build`
- **Run in Background**: `docker compose up --build -d`
- **Stop & Remove**: `docker compose down --volumes --remove-orphans`

**Development Commands**:
- **Rails Console**: `docker compose exec web rails c`
- **Run Tests**: `docker compose exec web rails test`
- **Run Migrations**: `docker compose exec web rails db:migrate`
- **View Logs**: `docker compose logs -f web`

### Docker Production Environment

**Production Commands**:
- **Setup**: `cp docker-compose.prod.yml.example docker-compose.prod.yml` (customize as needed)
- **Start**: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build`
- **Stop & Clean**: `docker compose -f docker-compose.yml -f docker-compose.prod.yml down --volumes`

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