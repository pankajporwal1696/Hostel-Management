class BookingSerializer < ActiveModel::Serializer
  attributes :id, :status, :start_date, :end_date, :created_at
  belongs_to :room
  belongs_to :resident, serializer: UserSerializer
end
