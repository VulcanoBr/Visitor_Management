class DepartmentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  def index
    @departments = Department.ordered_by_name_and_units
  end

  def show

  end

  def new
    @department = Department.new
    @units = Unit.order(:name)
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path, notice: 'Setor cadastrado com sucesso.'
    else
      @units = Unit.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @units = Unit.order(:name)
  end

  def update
    if @department.update(department_params)
      redirect_to departments_path, notice: 'Setor atualizado com sucesso.'
    else
      @units = Unit.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @department.destroy
      redirect_to departments_path, notice: 'Setor excluído com sucesso.'
    else
      redirect_to departments_path, alert: 'Não é possível excluir este setor pois ele possui registros associados.'
    end
  end

  private

  def set_department
    @department = Department.includes(:units).find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, :description, :active, unit_ids: [] )
  end
end
