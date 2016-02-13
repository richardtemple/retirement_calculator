class Calculator # < ActiveRecord::Base
  include ActiveModel::AttributeMethods
	include ActiveModel::Model
  
  attribute_method_suffix  '_as_percentage'
  define_attribute_methods :interest_rate, 
                           :inflation_rate, 
                           :post_retire_interest_rate, 
                           :retirement_tax_rate

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
  		public_send("#{attr}=", value)
  	end if params
    
  end

	def update #(attributes)
    if valid? 
      calculate
    else
      self
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

  private

    def attribute_as_percentage(attr)
      send("#{attr}").to_f / 100
    end

    # def make_boolean_of(value)
    #   return case value
    #     when "0" then false
    #     when 0 then false
    #     when "false" then false
    #     when "" then false
    #     when nil then false
    #     when false then false
    #     else true
    #   end
    # end

    def years_until_retirement
      @retirement_age.to_i - @current_age.to_i
    end

		def calculate

      Rails.logger.info (self.to_s)
	    current_savings = @current_savings.to_f

      current_savings = get_pre_retirement_calculations current_savings
      calculate_yearly_retirement current_savings

	    return self
	  end

    def get_pre_retirement_calculations current_savings

      current_contribution   = @annual_contributions.to_f
      
      years_until_retirement.to_i.times do 
        
        current_savings      = current_savings * (1 + interest_rate_as_percentage)
        current_savings      = current_savings + current_contribution
        
        if (inflate_contributions?)
          current_contribution = current_contribution * 
                                    (1 + inflation_rate_as_percentage)        
        end
      end

      current_savings #return
    end

    def calculate_yearly_retirement current_savings

      years_of_retirement  = @withdraw_until_age.to_i - @retirement_age.to_i
      inflation_rate_value = inflation_rate_as_percentage

      # To avoid divide by zero
      if (inflation_rate_value - post_retire_interest_rate_as_percentage == 0)
        inflation_rate_value = inflation_rate_value + 0.0000001
      end

      # http://www.financeformulas.net/
      numerator = post_retire_interest_rate_as_percentage - inflation_rate_value
      denominator = 1 - ((1 + inflation_rate_value)/
                            (1 + post_retire_interest_rate_as_percentage))**years_of_retirement

      yearly_ret_val_pretax = current_savings * (numerator/denominator)

      if (show_in_todays_dollars?)
        # PV * e ** rt 
        after_inflation_yearly_rate = 
            yearly_ret_val_pretax * 
              (Math::E ** ((-inflation_rate_as_percentage) * years_until_retirement))
        @yearly_retirement_income = 
          after_inflation_yearly_rate * (1 - retirement_tax_rate_as_percentage)
      else
        @yearly_retirement_income =  
          (yearly_ret_val_pretax) * (1 - retirement_tax_rate_as_percentage)
      end
      Rails.logger.info "yearly_retirement_income = #{yearly_retirement_income}"
    end
end
