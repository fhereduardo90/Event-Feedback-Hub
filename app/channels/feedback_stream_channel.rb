class FeedbackStreamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "feedback_stream"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
