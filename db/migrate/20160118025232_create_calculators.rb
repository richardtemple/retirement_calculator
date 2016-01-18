class CreateCalculators < ActiveRecord::Migration
  def change
    create_table :calculators do |t|
      t.float :current_savings
      t.float :interest_rate
      t.float :yearly_contributions
      t.boolean :inflate_contributions
      t.float :inflation_rate
      t.integer :current_age
      t.integer :retirement_age
      t.integer :withdraw_until_age
      t.float :post_retire_interest_rate
      t.float :retirement_tax_rate
      t.boolean :show_in_todays_dollars
      t.float :yearly_retirement_income

      t.timestamps null: false
    end
  end
end
