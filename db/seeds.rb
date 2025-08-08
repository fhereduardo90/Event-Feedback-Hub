# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample events for the Event Feedback Hub
events_data = [
  {
    name: "RailsConf 2024",
    description: "The premier conference for Ruby on Rails developers worldwide. Join us for three days of technical talks, workshops, and networking opportunities."
  },
  {
    name: "Ruby on Rails Workshop",
    description: "An intensive hands-on workshop covering advanced Rails concepts, best practices, and modern development techniques."
  },
  {
    name: "Modern Frontend with Rails Webinar",
    description: "Learn how to build modern frontend applications using Rails 8, Hotwire, and Turbo in this interactive webinar."
  },
  {
    name: "API Development with Rails",
    description: "Deep dive into building robust APIs with Rails, covering authentication, serialization, and performance optimization."
  },
  {
    name: "Testing Best Practices Workshop",
    description: "Master the art of testing Rails applications with practical examples, TDD principles, and testing strategies."
  },
  {
    name: "Rails Performance Conference",
    description: "Learn techniques to optimize Rails application performance, database queries, and scaling strategies."
  },
  {
    name: "Ruby Fundamentals Bootcamp",
    description: "A comprehensive bootcamp covering Ruby language fundamentals for beginners and intermediate developers."
  },
  {
    name: "DevOps for Rails Developers",
    description: "Essential DevOps practices for Rails applications including deployment, monitoring, and infrastructure management."
  },
  {
    name: "Rails Security Workshop",
    description: "Learn about common security vulnerabilities in Rails applications and how to prevent them effectively."
  },
  {
    name: "GraphQL with Rails Meetup",
    description: "Explore GraphQL implementation in Rails applications with practical examples and real-world use cases."
  }
]

puts "Creating events..."
events_data.each do |event_data|
  event = Event.find_or_create_by!(name: event_data[:name]) do |e|
    e.description = event_data[:description]
  end
  puts "✓ #{event.name}"
end

puts "\nSeeded #{Event.count} events successfully!"
