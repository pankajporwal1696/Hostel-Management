class Hostel < ApplicationRecord
  belongs_to :admin, class_name: 'Admin', foreign_key: 'admin_id'
  has_many :rooms, dependent: :destroy
    
  validates :name, :address, :city, :state, :country, :pincode, presence: true
end
