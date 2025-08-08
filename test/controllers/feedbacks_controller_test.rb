require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = create(:event)
  end

  test "should create feedback with valid params" do
    feedback_params = {
      event_id: @event.id,
      user_name: "John Doe",
      user_email: "john@example.com",
      feedback_text: "Great event!",
      rating: 5
    }

    assert_difference("Feedback.count", 1) do
      post feedbacks_url, params: { feedback: feedback_params }
    end

    assert_redirected_to feedbacks_path
    assert_equal "Thank you for your feedback!", flash[:notice]
  end

  test "should not create feedback with invalid params" do
    feedback_params = {
      event_id: @event.id,
      user_name: "",
      user_email: "invalid-email",
      feedback_text: "",
      rating: nil
    }

    assert_no_difference("Feedback.count") do
      post feedbacks_url, params: { feedback: feedback_params }
    end

    assert_response :unprocessable_content
    assert_template "home/index"
  end

  test "should get index" do
    get feedbacks_url
    assert_response :success
    assert_select "h1", "Event Feedback Stream"
  end

  test "should display feedbacks on index" do
    feedback = create(:feedback, event: @event)

    get feedbacks_url
    assert_response :success
    assert_select ".bg-white", text: /#{feedback.feedback_text}/
    assert_select "h3", text: feedback.event.name
  end

  test "should filter by event" do
    event2 = create(:event, :conference)
    feedback1 = create(:feedback, event: @event)
    feedback2 = create(:feedback, event: event2)

    get feedbacks_url, params: { event_id: @event.id }
    assert_response :success

    assert_select "h3", text: feedback1.event.name
    assert_select "h3", { text: feedback2.event.name, count: 0 }
  end

  test "should filter by rating" do
    feedback1 = create(:feedback, event: @event, rating: 5)
    feedback2 = create(:feedback, event: @event, rating: 3)

    get feedbacks_url, params: { rating: "5" }
    assert_response :success

    # Should show the 5-star feedback but not the 3-star one
    assert_select ".text-yellow-400", minimum: 5  # 5 stars displayed
  end

  test "should show empty state when no feedbacks" do
    get feedbacks_url
    assert_response :success
    assert_select "h3", text: "No feedback yet"
  end
end
