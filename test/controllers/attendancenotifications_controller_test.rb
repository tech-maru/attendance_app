require 'test_helper'

class AttendancenotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get attendancenotifications_new_url
    assert_response :success
  end

end
