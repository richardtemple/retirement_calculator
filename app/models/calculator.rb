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
    current_savings: 100.0,
    interest_rate: 8,
    annual_contributions: 20000.0,
    inflate_contributions: false,
    inflation_rate: 3,
    current_age: 45,
    retirement_age: 65,
    withdraw_until_age: 100,
    post_retire_interest_rate: 5,
    retirement_tax_rate: 9,
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

	    years_until_retirement = self.retirement_age.to_i - self.current_age.to_i
	    years_of_retirement = self.withdraw_until_age.to_i - self.retirement_age.to_i
	    current_savings = self.current_savings.to_f
	    current_contribution = self.annual_contributions.to_f
	    this_years_interest = self.interest_rate.to_f - self.inflation_rate.to_f 
	    Rails.logger.info "This years interest: " + this_years_interest.to_s

	    years_until_retirement.to_i.times do 
	        
	      current_savings     = current_savings * ((this_years_interest / 100) + 1)
	      current_savings     = current_savings + current_contribution

	      if (inflate_contributions?)
	        Rails.logger.info "Inflate contributions was true!"
	        current_contribution = current_contribution.to_i * (1 + (self.inflation_rate.to_f / 100))
	        Rails.logger.info "Current Contribution = " + current_contribution.to_s
	      end
	      Rails.logger.info current_savings
	    end

	    Rails.logger.info "Calc.post_retire_interest_rate.to_f / 100 = " + (self.post_retire_interest_rate.to_f / 100).to_s 

	    top_part = (self.post_retire_interest_rate.to_f / 100) * current_savings
	    bottom_part = 1 - (1 + (self.post_retire_interest_rate.to_f / 100))**(-years_of_retirement)
	    Rails.logger.info "top part = " + top_part.to_s
	    Rails.logger.info "bottom part = " + bottom_part.to_s

	    if (show_in_todays_dollars?)
        Rails.logger.info ("show_in_todays_dollars was checked")
	      # PV * e ** rt 
	      after_inflation_yearly_rate = 
	          (top_part / bottom_part) * 
	            (Math::E ** ((-self.inflation_rate.to_f / 100) * years_of_retirement))
	      @yearly_retirement_income = 
	        after_inflation_yearly_rate * (1-(self.retirement_tax_rate.to_f/100))
	    else
	      @yearly_retirement_income =  
	        (top_part / bottom_part)* (1-(self.retirement_tax_rate.to_f/100))
	    end
	    # Rails.logger.info(number_to_currency(10230.00))
	    Rails.logger.info "Retirement income should be... " + self.yearly_retirement_income.to_s
	    # self.save!
	    return self
	  end
end
