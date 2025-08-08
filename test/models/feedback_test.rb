require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    feedback = build(:feedback)
    assert feedback.valid?
  end

  test "should belong to event" do
    feedback = build(:feedback, event: nil)
    assert_not feedback.valid?
    assert_includes feedback.errors[:event], "must exist"
  end

  test "should require user_name" do
    feedback = build(:feedback, user_name: nil)
    assert_not feedback.valid?
    assert_includes feedback.errors[:user_name], "can't be blank"
  end

  test "should require user_email" do
    feedback = build(:feedback, user_email: nil)
    assert_not feedback.valid?
    assert_includes feedback.errors[:user_email], "can't be blank"
  end

  test "should validate email format" do
    feedback = build(:feedback, user_email: "invalid-email")
    assert_not feedback.valid?
    assert_includes feedback.errors[:user_email], "is invalid"
  end

  test "should require feedback_text" do
    feedback = build(:feedback, feedback_text: nil)
    assert_not feedback.valid?
    assert_includes feedback.errors[:feedback_text], "can't be blank"
  end

  test "should require rating" do
    feedback = build(:feedback, rating: nil)
    assert_not feedback.valid?
    assert_includes feedback.errors[:rating], "can't be blank"
  end

  test "should validate rating range" do
    feedback = build(:feedback, rating: 0)
    assert_not feedback.valid?
    assert_includes feedback.errors[:rating], "is not included in the list"

    feedback = build(:feedback, rating: 6)
    assert_not feedback.valid?
    assert_includes feedback.errors[:rating], "is not included in the list"
  end

  test "should allow ratings 1-5" do
    (1..5).each do |rating|
      feedback = build(:feedback, rating: rating)
      assert feedback.valid?, "Rating #{rating} should be valid"
    end
  end

  test "should limit text lengths" do
    feedback = build(:feedback, user_name: "a" * 101)
    assert_not feedback.valid?
    assert_includes feedback.errors[:user_name], "is too long (maximum is 100 characters)"

    feedback = build(:feedback, feedback_text: "a" * 1001)
    assert_not feedback.valid?
    assert_includes feedback.errors[:feedback_text], "is too long (maximum is 1000 characters)"
  end

  test "scopes should work correctly" do
    event1 = create(:event)
    event2 = create(:event, :conference)

    feedback1 = create(:feedback, event: event1, rating: 5)
    feedback2 = create(:feedback, event: event2, rating: 3)
    feedback3 = create(:feedback, event: event1, rating: 5)

    assert_includes Feedback.by_event(event1.id), feedback1
    assert_includes Feedback.by_event(event1.id), feedback3
    assert_not_includes Feedback.by_event(event1.id), feedback2

    assert_includes Feedback.by_rating(5), feedback1
    assert_includes Feedback.by_rating(5), feedback3
    assert_not_includes Feedback.by_rating(5), feedback2
  end
end
