class Room < ApplicationRecord
  belongs_to :hostel
  has_many :bookings, dependent: :destroy
  has_and_belongs_to_many :residents, class_name: 'Resident', join_table: :rooms_residents

  validates :number, :capacity, :price, presence: { message: "%{attribute} cannot be blank" }
  validates :capacity, :price, numericality: { greater_than: 0, message: "%{attribute} must be greater than 0" }

  def available?
    users.count < capacity
  end

  def update_availability!
    update!(available: residents.count < capacity)
  end
end