class Calculator < ActiveRecord::Base
	# include ActionView::Helpers::NumberHelper

	def calculate

    # retirement_age = 10
    # self.yearly_retirement_income = 1000

    

    years_until_retirement = self.retirement_age - self.current_age
    years_of_retirement = self.withdraw_until_age.to_i - self.retirement_age.to_i
    current_savings = self.current_savings
    current_contribution = self.yearly_contributions
    this_years_interest = self.interest_rate.to_f - self.inflation_rate.to_f 
    logger.info "This years interest: " + this_years_interest.to_s

    years_until_retirement.to_i.times do 
        
      current_savings     = current_savings * ((this_years_interest / 100) + 1)
      current_savings     = current_savings + current_contribution.to_i

      if (self.inflate_contributions) # Better way?!?
        logger.info "Inflate contributions was true!"
        current_contribution = current_contribution.to_i * (1 + (self.inflation_rate.to_f / 100))
        logger.info "Current Contribution = " + current_contribution.to_s
      end
      logger.info current_savings
    end

    logger.info "Calc.post_retire_interest_rate.to_f / 100 = " + (self.post_retire_interest_rate.to_f / 100).to_s 

    top_part = (self.post_retire_interest_rate.to_f / 100) * current_savings
    bottom_part = 1 - (1 + (self.post_retire_interest_rate.to_f / 100))**(-years_of_retirement)
    logger.info "top part = " + top_part.to_s
    logger.info "bottom part = " + bottom_part.to_s

    if (self.show_in_todays_dollars)
      # PV * e ** rt 
      after_inflation_yearly_rate = 
          (top_part / bottom_part) * 
            (Math::E ** ((-self.inflation_rate.to_f / 100) * years_of_retirement))
      self.yearly_retirement_income = 
        after_inflation_yearly_rate * (1-(self.retirement_tax_rate.to_f/100))
    else
      self.yearly_retirement_income =  
        (top_part / bottom_part)* (1-(self.retirement_tax_rate.to_f/100))
    end
    # logger.info(number_to_currency(10230.00))
    logger.info "Retirement income should be... " + self.yearly_retirement_income.to_s
    # self.save!
    return self
  end
end
