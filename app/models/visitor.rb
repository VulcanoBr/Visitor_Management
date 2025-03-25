class Visitor < ApplicationRecord

  has_one_attached :photo
  validates :name, :cpf, :phone, presence: true
  validates :cpf, uniqueness: true

  def formatted_cpf
    CPF.new(cpf).formatted if cpf.present?
  end

end
