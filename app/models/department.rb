class Department < ApplicationRecord

  has_many :unit_departments, dependent: :destroy
  has_many :units, through: :unit_departments
  has_many :employees, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  scope :ordered_by_name, -> { order(:name) }  # Renomeado e simplificado

  def self.ordered_by_name_and_units
    includes(:units).ordered_by_name
  end

end
