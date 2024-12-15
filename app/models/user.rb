class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  validates :name, presence: true

  def self.valid_types
    %w[Admin Resident]
  end

  def admin?
    type == 'Admin'
  end

  def resident?
    type == 'Resident'
  end
end
