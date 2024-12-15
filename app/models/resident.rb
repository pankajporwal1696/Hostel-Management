class Resident < User
	has_and_belongs_to_many :rooms, class_name: 'Room', join_table: :rooms_residents
  has_many :bookings, foreign_key: 'resident_id'
end