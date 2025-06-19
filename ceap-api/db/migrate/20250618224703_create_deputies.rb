class CreateDeputies < ActiveRecord::Migration[7.2]
  def change
    create_table :deputies do |t|
      t.string :name, null: false
      t.string :registration_id, null: false
      t.string :state, null: false, limit: 2
      t.string :party, null: false

      t.timestamps
    end
    
    add_index :deputies, :registration_id, unique: true
    add_index :deputies, :state
    add_index :deputies, [:state, :name]
  end
end
