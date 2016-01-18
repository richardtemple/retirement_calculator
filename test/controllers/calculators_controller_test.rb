require 'test_helper'

class CalculatorsControllerTest < ActionController::TestCase
  setup do
    @calculator = calculators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calculators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create calculator" do
    assert_difference('Calculator.count') do
      post :create, calculator: { current_age: @calculator.current_age, current_savings: @calculator.current_savings, inflate_contributions: @calculator.inflate_contributions, inflation_rate: @calculator.inflation_rate, interest_rate: @calculator.interest_rate, post_retire_interest_rate: @calculator.post_retire_interest_rate, retirement_age: @calculator.retirement_age, retirement_tax_rate: @calculator.retirement_tax_rate, show_in_todays_dollars: @calculator.show_in_todays_dollars, withdraw_until_age: @calculator.withdraw_until_age, yearly_contributions: @calculator.yearly_contributions, yearly_retirement_income: @calculator.yearly_retirement_income }
    end

    assert_redirected_to calculator_path(assigns(:calculator))
  end

  test "should show calculator" do
    get :show, id: @calculator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @calculator
    assert_response :success
  end

  test "should update calculator" do
    patch :update, id: @calculator, calculator: { current_age: @calculator.current_age, current_savings: @calculator.current_savings, inflate_contributions: @calculator.inflate_contributions, inflation_rate: @calculator.inflation_rate, interest_rate: @calculator.interest_rate, post_retire_interest_rate: @calculator.post_retire_interest_rate, retirement_age: @calculator.retirement_age, retirement_tax_rate: @calculator.retirement_tax_rate, show_in_todays_dollars: @calculator.show_in_todays_dollars, withdraw_until_age: @calculator.withdraw_until_age, yearly_contributions: @calculator.yearly_contributions, yearly_retirement_income: @calculator.yearly_retirement_income }
    assert_redirected_to calculator_path(assigns(:calculator))
  end

  test "should destroy calculator" do
    assert_difference('Calculator.count', -1) do
      delete :destroy, id: @calculator
    end

    assert_redirected_to calculators_path
  end
end
