require 'test_helper'

class EditnotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get editnotifications_new_url
    assert_response :success
  end

end
