class FeedbackFinderService
  def initialize(params = {})
    @params = params
  end

  def call
    feedbacks = Feedback.includes(:event).recent
    feedbacks = feedbacks.by_event(@params[:event_id]) if @params[:event_id].present?
    feedbacks = feedbacks.by_rating(@params[:rating]) if @params[:rating].present?
    feedbacks
  end
end
