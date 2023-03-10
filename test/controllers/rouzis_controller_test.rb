require "test_helper"

class RouzisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rouzis_index_url
    assert_response :success
  end

  test "should get show" do
    get rouzis_show_url
    assert_response :success
  end

  test "should get edit" do
    get rouzis_edit_url
    assert_response :success
  end
end
