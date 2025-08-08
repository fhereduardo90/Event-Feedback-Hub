class FeedbackCreatorService
  def initialize(params)
    @params = params
  end

  def call
    @feedback = Feedback.new(@params)

    if @feedback.save
      ActionCable.server.broadcast(
        "feedback_stream",
        {
          html: ApplicationController.render(partial: "feedbacks/feedback", locals: { feedback: @feedback })
        }
      )
    end

    @feedback
  end
end
