class RoomBookingService
  def initialize(booking)
    @booking = booking
    @room = booking.room
    @resident = booking.resident
  end

  def assign_resident_to_room
    add_resident_to_room
    update_room_availability
  end

  private

  def add_resident_to_room
    unless @room.residents.exists?(@resident.id)
      @room.residents << @resident
    end
  end

  def update_room_availability
    @room.update_availability!
  end
end
