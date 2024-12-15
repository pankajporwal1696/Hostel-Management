class CreateHostels < ActiveRecord::Migration[7.0]
  def change
    create_table :hostels do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.references :admin, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
