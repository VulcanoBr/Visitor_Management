class PositionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  def index
    @positions = Position.all
  end

  def show
    @employees = @position.employees
  end

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position_params)
    if @position.save
      redirect_to positions_path, notice: 'Função cadastrada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @position.update(position_params)
      redirect_to positions_path, notice: 'Função atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @position.destroy
      redirect_to positions_path, notice: 'Função excluída com sucesso.'
    else
      redirect_to positions_path, alert: 'Não é possível excluir esta função pois ela possui registros associados.'
    end
  end

  private

  def set_position
    @position = Position.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:name, :description, :active)
  end
end
