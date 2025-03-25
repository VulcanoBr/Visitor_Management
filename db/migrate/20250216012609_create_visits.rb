class CreateVisits < ActiveRecord::Migration[7.2]
  def change
    create_table :visits do |t|
      t.date :entry_date
      t.time :entry_time
      t.references :visitor, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
