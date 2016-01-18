class Calculator < ActiveRecord::Base
	def calculate

    retirement_age = 10
    yearly_retirement_income = 1000
    # years_until_retirement = this.retirement_age - this.current_age
    # years_of_retirement = @calculator.withdraw_until_age.to_i - @calculator.retirement_age.to_i
    # current_savings = @calculator.current_savings
    # current_contribution = @calculator.yearly_contributions
    # this_years_interest = @calculator.interest_rate.to_f - @calculator.inflation_rate.to_f 
    # logger.info "This years interest: " + this_years_interest.to_s

    # years_until_retirement.to_i.times do 
        
    #   current_savings     = current_savings * ((this_years_interest / 100) + 1)
    #   current_savings     = current_savings + current_contribution.to_i

    #   if (@calculator.inflate_contributions.to_i == 1) # Better way?!?
    #     logger.info "Inflate contributions was true!"
    #     current_contribution = current_contribution.to_i * (1 + (@calculator.inflation_rate.to_f / 100))
    #     logger.info "Current Contribution = " + current_contribution.to_s
    #   end
    #   logger.info current_savings
    # end

    # logger.info "Calc.post_retire_interest_rate.to_f / 100 = " + (@calculator.post_retire_interest_rate.to_f / 100).to_s 

    # top_part = (@calculator.post_retire_interest_rate.to_f / 100) * current_savings
    # bottom_part = 1 - (1 + (@calculator.post_retire_interest_rate.to_f / 100))**(-years_of_retirement)
    # logger.info "top part = " + top_part.to_s
    # logger.info "bottom part = " + bottom_part.to_s

    # if (@calculator.show_in_todays_dollars.to_i == 1)
    #   # PV * e ** rt 
    #   after_inflation_yearly_rate = 
    #       (top_part / bottom_part) * 
    #         (Math::E ** ((-@calculator.inflation_rate.to_f / 100) * years_of_retirement))
    #   @calculator.yearly_retirement_income = 
    #     number_to_currency(after_inflation_yearly_rate * (1-(@calculator.retirement_tax_rate.to_f/100)))
    # else
    #   @calculator.yearly_retirement_income =  
    #     number_to_currency((top_part / bottom_part)* (1-(@calculator.retirement_tax_rate.to_f/100)))
    # end
  end
end
