class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.references :deputy, null: false, foreign_key: true
      t.date :issue_date, null: false
      t.string :supplier, null: false
      t.decimal :net_value, precision: 10, scale: 2, null: false
      t.string :document_url, null: false
      t.string :expense_type

      t.timestamps
    end

    add_index :expenses, :issue_date
    add_index :expenses, :net_value
    add_index :expenses, [:deputy_id, :net_value]
  end
end
