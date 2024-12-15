class CreateRoomsResidentsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms_residents, id: false do |t|
      t.references :room, null: false, foreign_key: true, index: true
      t.references :resident, null: false, foreign_key: { to_table: :users }, index: true
    end

    add_index :rooms_residents, [:room_id, :resident_id], unique: true
  end
end
