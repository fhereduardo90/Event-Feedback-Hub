class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      # Broadcast the new feedback to all connected clients
      ActionCable.server.broadcast(
        "feedback_stream",
        {
          html: render_to_string(partial: "feedbacks/feedback", locals: { feedback: @feedback })
        }
      )
      redirect_to feedbacks_path, notice: "Thank you for your feedback!"
    else
      @events = Event.all.order(:name)
      render "home/index", status: :unprocessable_content
    end
  end

  def index
    @feedbacks = Feedback.includes(:event).recent

    # Apply filters
    @feedbacks = @feedbacks.by_event(params[:event_id]) if params[:event_id].present?
    @feedbacks = @feedbacks.by_rating(params[:rating]) if params[:rating].present?

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
