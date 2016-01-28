require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  test "should update yearly retirement income field" do
    calc = Calculator.new
    calc = calc.update(Calculator::DEFAULT_VALUES)

    # assert calc.yearly_retirement_income != nil,
    # 			"yearly_retirement_income should not be nil"
    assert calc.yearly_retirement_income == 52447.82779508144
  end

  test "should provide default values when new" do
    calc = Calculator.new
    assert (calc.current_savings > 0), "current_savings should have default value."
  end
end