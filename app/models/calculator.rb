class Calculator # < ActiveRecord::Base

	include ActiveModel::Model

  attr_accessor :current_savings,
                :interest_rate,
                :annual_contributions,
                :inflate_contributions,
                :inflation_rate,
                :current_age,
                :retirement_age,
                :withdraw_until_age,
                :post_retire_interest_rate,
                :retirement_tax_rate,
                :show_in_todays_dollars

  attr_reader :yearly_retirement_income

	validates_numericality_of :current_savings,
                            :interest_rate,
                            :annual_contributions,
                            :inflation_rate,
                            :current_age,
                            :retirement_age,
                            :withdraw_until_age,
                            :post_retire_interest_rate,
                            :retirement_tax_rate

	DEFAULT_VALUES = {
    current_savings: 100000.0,
    interest_rate: 8,
    annual_contributions: 20000.0,
    inflate_contributions: false,
    inflation_rate: 3,
    current_age: 45,
    retirement_age: 65,
    withdraw_until_age: 100,
    post_retire_interest_rate: 5,
    retirement_tax_rate: 7,
    show_in_todays_dollars: false
  }

  def initialize(params = DEFAULT_VALUES)
  	params.each do |attr, value|
  		self.public_send("#{attr}=", value)
  	end if params
  end

	def update(attributes)
    if self.valid? 
      calculate
    else
      # return validation errors
    end
  end

  def inflate_contributions?
    if @inflate_contributions == "1"
      true
    else
      false
    end
  end

  def show_in_todays_dollars?
    if @show_in_todays_dollars == "1"
      true
    else
      false
    end
  end

# This causes the checkbox to stay checked
  # def show_in_todays_dollars=(show)
  #   if show == 1
  #     @show_in_todays_dollars = true
  #   else
  #     @show_in_todays_dollars = false
  #   end
  # end


  private

		def calculate

	    current_savings = self.current_savings.to_f

      current_savings = pre_retirement_calculations current_savings
      retirement_calculations current_savings

	    Rails.logger.info "Retirement income should be... " + self.yearly_retirement_income.to_s
	    return self

	  end

    def pre_retirement_calculations current_savings

      years_until_retirement = self.retirement_age.to_i - self.current_age.to_i
      current_contribution   = self.annual_contributions.to_f

      this_years_interest  = (self.interest_rate.to_f) / 100

      years_until_retirement.to_i.times do 
        
        current_savings      = current_savings * (this_years_interest + 1)
        Rails.logger.info "Current savings after interest: #{current_savings}"
        current_savings      = current_savings + current_contribution
        Rails.logger.info "Current savings after payment: #{current_savings}"
        
        if (inflate_contributions?)
          Rails.logger.info "Inflate contributions was true."
          current_contribution = current_contribution * 
                                    (1 + (self.inflation_rate.to_f / 100))
          
          Rails.logger.info "Current Contribution = " + current_contribution.to_s
        end
        Rails.logger.info "Current savings: #{current_savings}"
      end

      current_savings #return
    end

    def retirement_calculations current_savings

      years_until_retirement = self.retirement_age.to_i - self.current_age.to_i
      years_of_retirement    = self.withdraw_until_age.to_i - self.retirement_age.to_i
      retirement_int_rate    = self.post_retire_interest_rate.to_f / 100
      infl_rate              = self.inflation_rate.to_f / 100
      
      # http://www.financeformulas.net/
      numerator = retirement_int_rate - infl_rate
      denominator = 1 - ((1 + infl_rate)/(1 + retirement_int_rate))**years_of_retirement

      yearly_ret_val_pretax = current_savings * (numerator/denominator)

      # should the current_savings value might need initial adjustment for 
      # inflation if show in today's dollars is checked?

      Rails.logger.info "numerator = " + numerator.to_s
      Rails.logger.info "denominator = " + denominator.to_s

      if (show_in_todays_dollars?)
        Rails.logger.info "show_in_todays_dollars was checked"
        # PV * e ** rt 
        after_inflation_yearly_rate = 
            yearly_ret_val_pretax * 
              (Math::E ** ((-self.inflation_rate.to_f / 100) * years_until_retirement))
        @yearly_retirement_income = 
          after_inflation_yearly_rate * (1-(self.retirement_tax_rate.to_f/100))
      else
        @yearly_retirement_income =  
          (yearly_ret_val_pretax) * (1-(self.retirement_tax_rate.to_f/100))
      end
    end

    def forfun current_savings
      years_of_retirement = self.withdraw_until_age.to_i - self.retirement_age.to_i
      retirement_int_rate = self.post_retire_interest_rate.to_f / 100
      infl_rate           = self.inflation_rate.to_f / 100
      
      numerator = retirement_int_rate - infl_rate
      denominator = 1 - ((1 + infl_rate)/(1 + retirement_int_rate))**years_of_retirement

      fun_yearly_retirement_val = current_savings * (numerator/denominator)
      Rails.logger.info "FOR FUN!!!!!!!!!!!!!!!!!!!!!!!!!"
      Rails.logger.info "numerator = #{numerator}"
      Rails.logger.info "denominator = #{denominator}"
      Rails.logger.info "Years of retirment = #{years_of_retirement}"
      Rails.logger.info "Inflation Rate = #{infl_rate}"
      Rails.logger.info "current_savings = #{current_savings}"
      Rails.logger.info "Payment in growth calc would be: #{fun_yearly_retirement_val}"
      Rails.logger.info "FOR FUN!!!!!!!!!!!!!!!!!!!!!!!!!"
    end
end
