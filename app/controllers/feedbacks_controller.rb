class FeedbacksController < ApplicationController
  def create
    @feedback = FeedbackCreatorService.new(feedback_params).call

    if @feedback.persisted?
      redirect_to feedbacks_path, notice: "Thank you for your feedback!"
    else
      @events = Event.all.order(:name)
      render "home/index", status: :unprocessable_content
    end
  end

  def index
    @feedbacks = FeedbackFinderService.new(params).call

    # Paginate
    @pagy, @feedbacks = pagy(@feedbacks)

    # For form and filters
    @feedback = Feedback.new
    @events = Event.all.order(:name)
  end

  private

  def feedback_params
    params.require(:feedback).permit(:event_id, :user_name, :user_email, :feedback_text, :rating)
  end
end
