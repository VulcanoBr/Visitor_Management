class UnitDepartment < ApplicationRecord

  belongs_to :unit
  belongs_to :department

  validates :unit_id, uniqueness: { scope: :department_id, message: "já possui este departamento" }

end
