require 'test_helper'

class SearchdateControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get searchdate_new_url
    assert_response :success
  end

end
