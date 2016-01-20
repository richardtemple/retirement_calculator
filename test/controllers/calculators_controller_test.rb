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
    patch :update, calculator: { current_age: @calculator.current_age, 
                                 current_savings: @calculator.current_savings, 
                                 inflate_contributions: @calculator.inflate_contributions, 
                                 inflation_rate: @calculator.inflation_rate, 
                                 interest_rate: @calculator.interest_rate, 
                                 post_retire_interest_rate: @calculator.post_retire_interest_rate, 
                                 retirement_age: @calculator.retirement_age, 
                                 retirement_tax_rate: @calculator.retirement_tax_rate, 
                                 show_in_todays_dollars: @calculator.show_in_todays_dollars, 
                                 withdraw_until_age: @calculator.withdraw_until_age, 
                                 annual_contributions: @calculator.annual_contributions, 
                                 yearly_retirement_income: @calculator.yearly_retirement_income }
    # assert_redirected_to calculator_path(assigns(:calculator))
    assert_response :success
  end
end
