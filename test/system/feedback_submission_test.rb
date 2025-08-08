require "application_system_test_case"

class FeedbackSubmissionTest < ApplicationSystemTestCase
  setup do
    @event = create(:event, name: "Ruby Conference 2024")
  end

  test "user can submit feedback successfully" do
    visit root_path

    assert_selector "h1", text: "Share Your Event Feedback"

    # Fill out the form
    select @event.name, from: "feedback_event_id"
    fill_in "feedback_user_name", with: "John Doe"
    fill_in "feedback_user_email", with: "john@example.com"
    fill_in "feedback_feedback_text", with: "This was an amazing conference!"

    # Click on 5 stars rating
    page.execute_script("document.querySelector('[data-rating=\"5\"]').click()")

    click_button "Submit Feedback"

    # Should redirect to feedback index and show success message
    assert_current_path feedbacks_path
    assert_text "Thank you for your feedback!"

    # Should see the submitted feedback
    assert_text "Ruby Conference 2024"
    assert_text "by John Doe"
    assert_text "This was an amazing conference!"
  end

  test "user sees validation errors for invalid feedback" do
    visit root_path

    # Submit form without required fields
    click_button "Submit Feedback"

    # Should show validation errors
    assert_text "Please fix the following errors:"
    assert_text "can't be blank"
  end

  test "user can view and filter feedback" do
    # Create some test feedback
    event2 = create(:event, :conference, name: "Rails Workshop")
    feedback1 = create(:feedback, event: @event, rating: 5, user_name: "Alice")
    feedback2 = create(:feedback, event: event2, rating: 3, user_name: "Bob")

    visit feedbacks_path

    assert_selector "h1", text: "Event Feedback Stream"

    # Should see both feedbacks
    assert_text "by Alice"
    assert_text "by Bob"

    # Filter by event
    select @event.name, from: "event_id"
    click_button "Filter"

    # Should only see Alice's feedback
    assert_text "by Alice"
    assert_no_text "by Bob"

    # Clear filters
    click_link "Clear"

    # Should see both feedbacks again
    assert_text "by Alice"
    assert_text "by Bob"

    # Filter by rating
    select "5 Stars", from: "rating"
    click_button "Filter"

    # Should only see 5-star feedback
    assert_text "by Alice"
    assert_no_text "by Bob"
  end

  test "empty state is shown when no feedback exists" do
    visit feedbacks_path

    assert_text "No feedback yet"
    assert_text "Be the first to share your event experience!"
    assert_link "Submit Feedback"
  end
end
