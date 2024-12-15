class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :number
      t.integer :capacity
      t.decimal :price, precision: 10, scale: 2
      t.boolean :available, default: true
      t.references :hostel, null: false, foreign_key: true

      t.timestamps
    end
  end
end