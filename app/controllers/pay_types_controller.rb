class PayTypesController < ApplicationController
  before_action :set_pay_type, only: [:show, :edit, :update, :destroy]

  # GET /pay_types
  # GET /pay_types.json
  def index
    @pay_types = PayType.all
  end

  # GET /pay_types/1
  # GET /pay_types/1.json
  def show
  end

  # GET /pay_types/new
  def new
    @pay_type = PayType.new
  end

  # GET /pay_types/1/edit
  def edit
  end

  # POST /pay_types
  # POST /pay_types.json
  def create
    @pay_type = PayType.new(pay_type_params)

    respond_to do |format|
      if @pay_type.save
        format.html { redirect_to @pay_type, notice: 'Pay type was successfully created.' }
        format.json { render :show, status: :created, location: @pay_type }
      else
        format.html { render :new }
        format.json { render json: @pay_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pay_types/1
  # PATCH/PUT /pay_types/1.json
  def update
    respond_to do |format|
      if @pay_type.update(pay_type_params)
        format.html { redirect_to @pay_type, notice: 'Pay type was successfully updated.' }
        format.json { render :show, status: :ok, location: @pay_type }
      else
        format.html { render :edit }
        format.json { render json: @pay_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_types/1
  # DELETE /pay_types/1.json
  def destroy
    @pay_type.destroy
    respond_to do |format|
      format.html { redirect_to pay_types_url, notice: 'Pay type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_type
      @pay_type = PayType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pay_type_params
      params.require(:pay_type).permit(:name)
    end
end
