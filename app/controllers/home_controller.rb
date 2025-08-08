class HomeController < ApplicationController
  def index
    @feedback = Feedback.new
    @events = Event.all.order(:name)
  end
end
