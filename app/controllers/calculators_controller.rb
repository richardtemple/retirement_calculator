class CalculatorsController < ApplicationController
  before_action :set_calculator, only: [:edit, :update]

  def new
    @calculator = Calculator.new
    respond_to do |format|
      format.html { render :edit }
      format.js
    end
  end

  # PATCH/PUT /calculators/1
  # PATCH/PUT /calculators/1.json
  def update
    Rails.logger.info "Begin update"
    if @calculator.update
      respond_to do |format|
        format.html { render :edit, notice: 'Calculator was successfully updated.' }
        format.js
        format.json { render :show, status: :ok, location: @calculator }
      end
    else
        Rails.logger.info "Calculator wasn't valid"
        respond_to do |format|
          format.js { render :edit }
          format.html { render :edit }
          format.json { render json: @calculator.errors, status: :unprocessable_entity }
        end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calculator
      Rails.logger.info "set_calculator"
      @calculator = Calculator.new(calculator_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calculator_params
      if params[:calculator]
        params.require(:calculator).permit(:current_savings, 
                                           :interest_rate, 
                                           :annual_contributions, 
                                           :inflate_contributions, 
                                           :inflation_rate, 
                                           :current_age, 
                                           :retirement_age, 
                                           :withdraw_until_age, 
                                           :post_retire_interest_rate, 
                                           :retirement_tax_rate, 
                                           :show_in_todays_dollars)
      end
    end
end
