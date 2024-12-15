class BookingsController < ApplicationController
  before_action -> { authorize_user!(%w[Resident]) }, only: [:create]
  before_action -> { authorize_user!(%w[Admin]) }, only: [:approve, :reject]

  def index
    bookings = current_user.admin? ? Booking.includes(:room, :resident).all : current_user.bookings.includes(:room)
    if bookings.empty?
      render json: { message: 'No bookings found' }, status: :ok
    else
      render json: bookings, each_serializer: BookingSerializer, status: :ok
    end
  end

  def create
    room = Room.find(params[:room_id])
    if room.residents.count >= room.capacity
      render json: { error: 'Room is fully booked.' }, status: :unprocessable_entity
    else
      booking = room.bookings.new(booking_params.merge(resident: current_user, status: :pending_approval))
      if booking.save
        render json: booking, serializer: BookingSerializer, status: :created
      else
        render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def approve
    booking = Booking.find(params[:id])
    
    if booking.update!(status: :approved)
      RoomBookingService.new(booking).assign_resident_to_room
      render json: booking, serializer: BookingSerializer, status: :ok
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reject
    booking = Booking.find(params[:id])
    booking.update!(status: :rejected)
    render json: booking, serializer: BookingSerializer, status: :ok
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end