require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    event = build(:event)
    assert event.valid?
  end

  test "should require name" do
    event = build(:event, name: nil)
    assert_not event.valid?
    assert_includes event.errors[:name], "can't be blank"
  end

  test "should require description" do
    event = build(:event, description: nil)
    assert_not event.valid?
    assert_includes event.errors[:description], "can't be blank"
  end

  test "should limit name length" do
    event = build(:event, name: "a" * 256)
    assert_not event.valid?
    assert_includes event.errors[:name], "is too long (maximum is 255 characters)"
  end

  test "should limit description length" do
    event = build(:event, description: "a" * 1001)
    assert_not event.valid?
    assert_includes event.errors[:description], "is too long (maximum is 1000 characters)"
  end

  test "should have many feedbacks" do
    event = create(:event)
    feedback1 = create(:feedback, event: event)
    feedback2 = create(:feedback, event: event)

    assert_includes event.feedbacks, feedback1
    assert_includes event.feedbacks, feedback2
  end

  test "should destroy associated feedbacks when event is destroyed" do
    event = create(:event)
    feedback = create(:feedback, event: event)

    assert_difference "Feedback.count", -1 do
      event.destroy
    end
  end
end
