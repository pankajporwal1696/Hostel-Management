class RoomSerializer < ActiveModel::Serializer
  attributes :id, :number, :capacity, :price, :available, :hostel_id, :residents

  def residents
    object.residents.map do |resident|
      {
        id: resident.id,
        name: resident.name, 
        email: resident.email
      }
    end
  end
end
