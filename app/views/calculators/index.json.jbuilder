json.array!(@calculators) do |calculator|
  json.extract! calculator, :id, :current_savings, :interest_rate, :yearly_contributions, :inflate_contributions, :inflation_rate, :current_age, :retirement_age, :withdraw_until_age, :post_retire_interest_rate, :retirement_tax_rate, :show_in_todays_dollars, :yearly_retirement_income
  json.url calculator_url(calculator, format: :json)
end
