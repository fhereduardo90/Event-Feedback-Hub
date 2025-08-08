require "test_helper"

class FeedbackCreatorServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper
  test "should create feedback and broadcast it" do
    event = FactoryBot.create(:event)
    feedback_params = { event_id: event.id, user_name: "Test User", user_email: "test@example.com", feedback_text: "Great event!", rating: 5 }

    assert_difference("Feedback.count", 1) do
      assert_broadcasts("feedback_stream", 1) do
        service = FeedbackCreatorService.new(feedback_params)
        service.call
      end
    end
  end

  test "should not create feedback with invalid data" do
    feedback_params = { user_name: "Test User" }

    assert_no_difference("Feedback.count") do
      assert_no_broadcasts("feedback_stream") do
        service = FeedbackCreatorService.new(feedback_params)
        service.call
      end
    end
  end
end
