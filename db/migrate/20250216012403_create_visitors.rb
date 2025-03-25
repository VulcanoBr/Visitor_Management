class CreateVisitors < ActiveRecord::Migration[7.2]
  def change
    create_table :visitors do |t|
      t.string :name
      t.string :cpf
      t.string :phone
      t.string :company

      t.timestamps
    end
  end
end
