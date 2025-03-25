class VisitsController < ApplicationController

  def new
    @employee = Employee.order(:name)

    @visit = Visit.new
    @visitor = Visitor.new
  end

  def create
    @visit = Visit.new(visit_params)

    if @visit.save
      redirect_to new_visit_path, notice: 'Visit was successfully created.'
    else
      @visitor = visit_params[:visitor_id].present? ? Visitor.find(visit_params[:visitor_id]) : Visitor.new
      render :new, status: :unprocessable_entity
    end
  end

  private

  def visit_params
    params.require(:visit).permit(:visitor_id, :employee_id, :unit_id, :department_id)
  end
end
