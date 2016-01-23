class CalculatorsController < ApplicationController
  before_action :set_calculator, only: [:edit, :update]

  # GET /calculators
  # GET /calculators.json
  # def index
  #   @calculators = Calculator.all
  # end

  # # GET /calculators/1
  # # GET /calculators/1.json
  # def show
  # end

  def new
    @calculator = Calculator.new
    respond_to do |format|
      format.html { render :edit }
    end
  end

  # GET /calculators/1/edit
  def edit
  end

  # # POST /calculators
  # # POST /calculators.json
  # def create
  #   Rails.logger.info "create start"
  #   @calculator = Calculator.new #(calculator_params).update

  #   respond_to do |format|
  #     if @calculator.save
  #       format.html { redirect_to @calculator, notice: 'Calculator was successfully created.' }
  #       format.json { render :show, status: :created, location: @calculator }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @calculator.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /calculators/1
  # PATCH/PUT /calculators/1.json
  def update
    Rails.logger.info "update start"
    respond_to do |format|
      if @calculator.update(calculator_params)
        format.html { render :edit, notice: 'Calculator was successfully updated.' }
        format.json { render :show, status: :ok, location: @calculator }
      else
        format.html { render :edit }
        format.json { render json: @calculator.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /calculators/1
  # # DELETE /calculators/1.json
  # def destroy
  #   @calculator.destroy
  #   respond_to do |format|
  #     format.html { redirect_to calculators_url, notice: 'Calculator was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

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
