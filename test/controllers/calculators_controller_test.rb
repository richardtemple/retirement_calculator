require 'test_helper'

class CalculatorsControllerTest < ActionController::TestCase
  TESTVALS = {

  }

  test "should get edit" do
    get :edit #, id: @calculator
    assert_response :success
  end

  test "should update calculator" do
    @calculator = Calculator.new(TESTVALS)
    patch :update
    # assert_redirected_to calculator_path(assigns(:calculator))
    assert_response :success
  end
end
