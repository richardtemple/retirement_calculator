require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  test "should update yearly retirement income field" do
    calc = Calculator.new
    calc = calc.update
    assert calc.yearly_retirement_income == 52447.82779508144, 
          "Expected: 52447.82779508144. Actual: #{calc.yearly_retirement_income}"
  end

  test "should update yearly retirement with inflated contributions" do
    calc = Calculator.new
    calc.inflate_contributions = "1"
    assert calc.yearly_retirement_income == nil, "Calculator output should be nil still"
    calc = calc.update 
    assert calc.yearly_retirement_income == 61055.35181063842, 
          "Expected: 61055.35181063842. Actual: #{calc.yearly_retirement_income} "
  end

  test "should provide default values when new" do
    calc = Calculator.new
    assert (calc.current_savings > 0), "current_savings should have default value."
  end

  test "shouldn't return an ARI if the calculating values are invalid" do
    calc = Calculator.new
    calc.current_savings = "abcd"
    assert calc.yearly_retirement_income == nil, "Calculator output should be nil still"
    calc = calc.update 
    assert calc.yearly_retirement_income == nil,
          "Expected: error. Actual: #{calc.yearly_retirement_income} "
  end

  test "should correctly calculate the ARI in today's dollars" do
    calc = Calculator.new
    calc.show_in_todays_dollars = "1"
    assert calc.yearly_retirement_income == nil, "Calculator output should be nil still"
    calc = calc.update 
    assert calc.yearly_retirement_income == 28783.9781817964, 
          "Expected: 28783.9781817964. Actual: #{calc.yearly_retirement_income} "
  end

end