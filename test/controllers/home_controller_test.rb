require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "h1", "Share Your Event Feedback"
    assert_select "form"
  end

  test "should load events for dropdown" do
    event = create(:event)
    get root_url
    assert_response :success
    assert_select "select[name='feedback[event_id]']"
    assert_select "option", text: event.name
  end

  test "should initialize new feedback object" do
    get root_url
    assert_response :success
    assert assigns(:feedback).is_a?(Feedback)
    assert assigns(:feedback).new_record?
  end
end
