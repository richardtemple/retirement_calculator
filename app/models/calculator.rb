class Calculator # < ActiveRecord::Base
  # include ActiveAttr::Model
  # include ActiveAttr::TypecastedAttributes
	include ActiveModel::Model
  
  
  # attribute :current_savings, :type => Integer, :default => 20

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

  # def current_savings
  #   @current_savings.to_f
  # end

  # def current_savings=(value)
  #   @current_savings = value.to_f
  # end

  def initialize(params = DEFAULT_VALUES)

  	params.each do |attr, value|
  		public_send("#{attr}=", value)
  	end if params
    
  end

	def update(attributes)
    if valid? 
      calculate
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

    def interest_rate_decimal
      @interest_rate.to_f / 100
    end

    def inflation_rate_decimal
      @inflation_rate.to_f / 100
    end

    def retirement_int_rate_decimal
      @post_retire_interest_rate.to_f / 100
    end

    def retirement_tax_rate_decimal
      @retirement_tax_rate.to_f / 100
    end

		def calculate

	    current_savings = @current_savings.to_f

      current_savings = pre_retirement_calculations current_savings
      calculate_yearly_retirement current_savings

	    return self

	  end

    def pre_retirement_calculations current_savings

      years_until_retirement = @retirement_age.to_i - @current_age.to_i
      current_contribution   = @annual_contributions.to_f
      
      years_until_retirement.to_i.times do 
        
        current_savings      = current_savings * (1 + interest_rate_decimal)
        current_savings      = current_savings + current_contribution
        
        if (inflate_contributions?)
          current_contribution = current_contribution * 
                                    (1 + inflation_rate_decimal)        
        end
      end

      current_savings #return
    end

    def calculate_yearly_retirement current_savings

      years_until_retirement = @retirement_age.to_i - @current_age.to_i
      years_of_retirement    = @withdraw_until_age.to_i - @retirement_age.to_i
      
      # http://www.financeformulas.net/
      numerator = retirement_int_rate_decimal - inflation_rate_decimal
      denominator = 1 - ((1 + inflation_rate_decimal)/(1 + retirement_int_rate_decimal))**years_of_retirement

      yearly_ret_val_pretax = current_savings * (numerator/denominator)

      if (show_in_todays_dollars?)
        # PV * e ** rt 
        after_inflation_yearly_rate = 
            yearly_ret_val_pretax * 
              (Math::E ** ((-inflation_rate_decimal) * years_until_retirement))
        @yearly_retirement_income = 
          after_inflation_yearly_rate * (1 - retirement_tax_rate_decimal)
      else
        @yearly_retirement_income =  
          (yearly_ret_val_pretax) * (1 - retirement_tax_rate_decimal)
      end
    end
end
