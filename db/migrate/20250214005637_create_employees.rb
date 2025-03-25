class CreateEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.references :unit, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :employees, :email, unique: true
  end
end
