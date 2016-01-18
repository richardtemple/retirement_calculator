class CalculatorsController < ApplicationController
  before_action :set_calculator, only: [:show, :edit, :update, :destroy]

  # GET /calculators
  # GET /calculators.json
  def index
    @calculators = Calculator.all
  end

  # GET /calculators/1
  # GET /calculators/1.json
  def show
  end

  # GET /calculators/new
  def new
    @calculator = Calculator.new
  end

  # GET /calculators/1/edit
  def edit
  end

  # POST /calculators
  # POST /calculators.json
  def create
    @calculator = Calculator.new(calculator_params)
    @calculator.calculate
    respond_to do |format|
      if @calculator.save
        format.html { redirect_to @calculator, notice: 'Calculator was successfully created.' }
        format.json { render :show, status: :created, location: @calculator }
      else
        format.html { render :new }
        format.json { render json: @calculator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calculators/1
  # PATCH/PUT /calculators/1.json
  def update
    respond_to do |format|
      if @calculator.update(calculator_params)
        format.html { redirect_to @calculator, notice: 'Calculator was successfully updated.' }
        format.json { render :show, status: :ok, location: @calculator }
      else
        format.html { render :edit }
        format.json { render json: @calculator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calculators/1
  # DELETE /calculators/1.json
  def destroy
    @calculator.destroy
    respond_to do |format|
      format.html { redirect_to calculators_url, notice: 'Calculator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calculator
      @calculator = Calculator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calculator_params
      params.require(:calculator).permit(:current_savings, :interest_rate, :yearly_contributions, :inflate_contributions, :inflation_rate, :current_age, :retirement_age, :withdraw_until_age, :post_retire_interest_rate, :retirement_tax_rate, :show_in_todays_dollars, :yearly_retirement_income)
    end
end
