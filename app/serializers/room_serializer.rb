class RoomSerializer < ActiveModel::Serializer
  attributes :id, :number, :capacity, :price, :available, :hostel_id, :residents

  def residents
    object.residents.map do |resident|
      {
        id: resident.id,
        name: resident.name, # Assumes Resident/User model has a `name` attribute
        email: resident.email # Assumes Resident/User model has an `email` attribute
      }
    end
  end
end
