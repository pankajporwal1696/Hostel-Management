class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :room, null: false, foreign_key: true
      t.references :resident, null: false, foreign_key: { to_table: :users }
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end