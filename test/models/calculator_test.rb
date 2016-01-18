require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  test "should update yearly retirement income field" do
    calc = Calculator.create
    calc.calculate
    assert calc.yearly_retirement_income != nil, 
    		"Yearly income should not be nil."
  end
end
