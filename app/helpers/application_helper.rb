module ApplicationHelper
  include Pagy::Frontend

  def star_rating(rating)
    content_tag :div, class: "flex items-center" do
      (1..5).map do |star|
        content_tag :span, "★", class: "text-lg #{star <= rating ? 'text-yellow-400' : 'text-gray-300'}"
      end.join.html_safe
    end
  end
end
