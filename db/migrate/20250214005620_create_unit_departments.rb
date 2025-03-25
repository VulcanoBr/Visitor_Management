class CreateUnitDepartments < ActiveRecord::Migration[7.2]
  def change
    create_table :unit_departments do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
    add_index :unit_departments, [:unit_id, :department_id], unique: true
  end
end
