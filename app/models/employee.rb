class Employee < ApplicationRecord

  belongs_to :unit
  belongs_to :department
  belongs_to :position

  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :position, presence: true
  validate :department_belongs_to_unit

  scope :ordered, -> {
    joins(:unit, :department)
    .order('units.name ASC, departments.name ASC, employees.name ASC')
  }

  scope :active, -> { where(active: true) }

  private

  def department_belongs_to_unit
    if unit.present? && department.present?
      unless unit.departments.include?(department)
        errors.add(:department, "não pertence à unit selecionada")
      end
    end
  end

end
