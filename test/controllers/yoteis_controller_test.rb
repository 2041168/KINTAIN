require "test_helper"

class YoteisControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get yoteis_edit_url
    assert_response :success
  end

  test "should get new" do
    get yoteis_new_url
    assert_response :success
  end
end
