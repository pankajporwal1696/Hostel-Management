class BookingSerializer < ActiveModel::Serializer
  attributes :id, :status, :start_date, :end_date, :created_at, :booking_request_by
  belongs_to :room

  def booking_request_by
    UserSerializer.new(object.resident).attributes
  end
end

