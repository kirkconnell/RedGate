require 'test_helper'

class GatesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "non existant gates should return 404" do
    get :apples
    assert_not_nil assigns(:error)
  end
end
