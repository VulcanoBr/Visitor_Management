class UnitsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_unit, only: [:show, :edit, :update, :destroy, :employees]

  def index
    @units = Unit.all
  end

  def show

  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      redirect_to units_path, notice: 'Unidade cadastrada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @unit.update(unit_params)
      redirect_to units_path, notice: 'Unidade atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @unit.destroy
      redirect_to units_path, notice: 'Unidade excluída com sucesso.'
    else
      redirect_to units_path, alert: 'Não é possível excluir esta unidade pois ela possui registros associados.'
    end
  end

  def employees
    @employees = @unit.employees.active.includes(:department, :position)

    respond_to do |format|
      format.json { render json: @employees.map { |e| { id: e.id, name: e.name, department_name: e.department.name, position_name: e.position.name } } }
    end
  end

  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:name, :description, :active)
  end
end
