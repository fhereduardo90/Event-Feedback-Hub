require "test_helper"

class FeedbackFinderServiceTest < ActiveSupport::TestCase
  setup do
    @event1 = FactoryBot.create(:event)
    @event2 = FactoryBot.create(:event, :conference)
    @feedback1 = FactoryBot.create(:feedback, event: @event1, rating: 5)
    @feedback2 = FactoryBot.create(:feedback, event: @event2, rating: 3)
  end

  test "should return all feedbacks when no params are given" do
    service = FeedbackFinderService.new
    assert_equal 2, service.call.count
  end

  test "should filter by event" do
    service = FeedbackFinderService.new(event_id: @event1.id)
    assert_equal 1, service.call.count
    assert_equal @feedback1, service.call.first
  end

  test "should filter by rating" do
    service = FeedbackFinderService.new(rating: 3)
    assert_equal 1, service.call.count
    assert_equal @feedback2, service.call.first
  end

  test "should filter by event and rating" do
    feedback3 = FactoryBot.create(:feedback, event: @event1, rating: 3)
    service = FeedbackFinderService.new(event_id: @event1.id, rating: 3)
    assert_equal 1, service.call.count
    assert_equal feedback3, service.call.first
  end
end
