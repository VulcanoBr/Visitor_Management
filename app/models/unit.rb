class Unit < ApplicationRecord

  has_many :unit_departments
  has_many :departments, through: :unit_departments
  has_many :employees, dependent: :restrict_with_error
  has_many :visits, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  default_scope { order(:name) }

  def to_s
    name
  end
end
