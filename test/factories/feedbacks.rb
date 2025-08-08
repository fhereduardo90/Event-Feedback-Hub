FactoryBot.define do
  factory :feedback do
    association :event
    user_name { "John Doe" }
    user_email { "john.doe@example.com" }
    feedback_text { "This was an excellent event! I learned a lot and would definitely recommend it to others." }
    rating { 5 }

    trait :negative do
      feedback_text { "The event could have been better organized. Some technical issues prevented smooth delivery." }
      rating { 2 }
    end

    trait :neutral do
      feedback_text { "It was an okay event. Some parts were interesting, others not so much." }
      rating { 3 }
    end
  end
end
