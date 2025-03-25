class EmployeesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = Employee.ordered.all
  end

  def show
  end

  def new
    @employee = Employee.new
    @positions = Position.order(:name)
    @units = Unit.order(:name)
    @departments = []
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employees_path, notice: 'Funcionário cadastrado com sucesso.'
    else
      @positions = Position.order(:name)
      @units = Unit.order(:name)
      @departments = @employee.unit ? @employee.unit.departments.order(:name) : []
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @positions = Position.order(:name)
    @units = Unit.order(:name)
    @departments = @employee.unit.departments
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: 'Funcionário atualizado com sucesso.'
    else
      @positions = Position.order(:name)
      @units = Unit.order(:name)
      @departments = @employee.unit ? @employee.unit.departments.order(:name) : []
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: 'Funcionário excluído com sucesso.'
    else
      redirect_to employees_path, alert: 'Não é possível excluir este funcionário pois ele possui registros associados.'
    end
  end

  def departments_por_unit
    @departments = Unit.find(params[:unit_id]).departments.order(:name)

    respond_to do |format|
      format.json { render json: @departments }
    end
  end

  def search
    return render json: [] if params[:q].blank?

    query = params[:q].to_s.strip.downcase
    @employees = Employee.includes(:unit, :department)
                         .where("LOWER(employees.name) LIKE ?", "%#{query}%")
                         .limit(10)
                         .select(:id, :name, :unit_id, :department_id)

    result = @employees.map do |employee|
      {
        id: employee.id,
        text: "#{employee.name} - #{employee.unit&.name} - #{employee.department&.name}",
        name: employee.name,
        unit_id: employee.unit_id,
        department_id: employee.department_id,
        unit_name: employee.unit&.name,
        department_name: employee.department&.name
      }
    end

    #render json: result
    render layout: false
  end


  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :unit_id, :department_id, :position_id, :employee_id, :active)
  end
end
