require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  test "should update yearly retirement income field" do
    calc = Calculator.new
    calc.current_savings       = 10000
    calc.interest_rate         = 8
    calc.annual_contributions  = 20000
    calc.inflate_contributions = 0
    calc.inflation_rate        = 3
    calc.current_age           = 45
    calc.retirement_age        = 65
    calc.withdraw_until_age    = 100
    calc.post_retire_interest_rate = 5
    calc.retirement_tax_rate   = 7
    calc.show_in_todays_dollars = 0
    calc = calc.update(Calculator::DEFAULT_VALUES) 
    assert calc != nil, "calc shouldn't be nil"

    assert calc.yearly_retirement_income != nil,
    			"yearly_retirement_income should not be nil"
  end

  test "should provide default values when new" do
  end
  
end