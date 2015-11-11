require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response 302
  end

  test "search for ' '(space)" do
    get :new, { :q => ' ' }
    assert_redirected_to root_url
  end

  test "search for (nothing)" do
    get :new, { :q => '' }
    assert_redirected_to root_url
  end

end
