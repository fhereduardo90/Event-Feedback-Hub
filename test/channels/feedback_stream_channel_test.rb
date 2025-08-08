require "test_helper"

class FeedbackStreamChannelTest < ActionCable::Channel::TestCase
  test "subscribes to feedback stream" do
    subscribe
    assert subscription.confirmed?
    assert_has_stream "feedback_stream"
  end

  test "unsubscribes from feedback stream" do
    subscribe
    unsubscribe
    assert_no_streams
  end

  test "broadcasts new feedback" do
    event = create(:event)
    feedback = create(:feedback, event: event)

    assert_broadcast_on("feedback_stream", {
      html: ApplicationController.render(
        partial: "feedbacks/feedback",
        locals: { feedback: feedback }
      )
    }) do
      ActionCable.server.broadcast(
        "feedback_stream",
        {
          html: ApplicationController.render(
            partial: "feedbacks/feedback",
            locals: { feedback: feedback }
          )
        }
      )
    end
  end
end
