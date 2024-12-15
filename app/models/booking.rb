class Booking < ApplicationRecord
	belongs_to :room
	belongs_to :resident

	enum status: [:pending_approval, :approved, :rejected]

	validates :start_date, :end_date, presence: true
	validate :valid_date_range

  private

  def valid_date_range
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:end_date, 'must be after the start date')
    end
  end
end
