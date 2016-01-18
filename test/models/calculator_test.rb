require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  test "should update yearly retirement income field" do
    calc = Calculator.new.calculate
    
    assert calc != nil, "calc shouldn't be nil"

    assert calc.yearly_retirement_income != nil,
    			"yearly_retirement_income should not be nil"
    assert calc.yearly_retirement_income == 1000,
     "Am I right?"
	end
end