class BookingsController < ApplicationController
  before_action -> { authorize_user!(%w[Resident]) }, only: [:create]
  before_action -> { authorize_user!(%w[Admin]) }, only: [:approve, :reject]
  before_action :set_booking, only: [:approve, :reject]

  def index
    bookings = current_user.admin? ? Booking.includes(:room, :resident).all : current_user.bookings.includes(:room)
    if bookings.empty?
      render json: { message: 'No bookings found' }, status: :ok
    else
      render json: bookings, each_serializer: BookingSerializer, status: :ok
    end
  end

  def create
    room = find_room
    return unless room

    if room_full?(room)
      render json: { error: 'Room is fully booked.' }, status: :unprocessable_entity
    elsif existing_booking?(room)
      render json: { error: 'You already have a pending or approved booking for this room.' }, status: :unprocessable_entity
    else
      create_booking(room)
    end
  end

  def approve
    if @booking.pending_approval?
      if @booking.update!(status: :approved)
        RoomBookingService.new(@booking).assign_resident_to_room
        render json: @booking, serializer: BookingSerializer, status: :ok
      else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Can't approve, Booking already rejected." }, status: :unprocessable_entity
    end
  end

  def reject
    if @booking.pending_approval?
      @booking.update!(status: :rejected)
      render json: @booking, serializer: BookingSerializer, status: :ok
    else
      render json: { error: "Can't reject, Booking is already approved." }, status: :unprocessable_entity
    end
  end

  private

  def find_room
    room = Room.find_by(id: params[:room_id])
    render(json: { error: 'Room not found.' }, status: :not_found) unless room
    room
  end

  def room_full?(room)
    room.residents.count >= room.capacity
  end

  def existing_booking?(room)
    room.bookings.where(resident: current_user).where(status: [:pending_approval, :approved]).exists?
  end

  def create_booking(room)
    booking = room.bookings.new(booking_params.merge(resident: current_user, status: :pending_approval))
    if booking.save
      render json: booking, serializer: BookingSerializer, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_booking
    @booking = Booking.find_by(id: params[:id])
    render json: { error: 'Booking not found.' }, status: :not_found unless @booking
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
