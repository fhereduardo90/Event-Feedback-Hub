FactoryBot.define do
  factory :event do
    name { "Ruby on Rails Workshop" }
    description { "An intensive workshop covering advanced Rails concepts and best practices." }

    trait :conference do
      name { "RailsConf 2024" }
      description { "The premier conference for Ruby on Rails developers worldwide." }
    end

    trait :webinar do
      name { "Modern Frontend with Rails" }
      description { "Learn how to build modern frontend applications using Rails and Hotwire." }
    end
  end
end
