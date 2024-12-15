class RoomsController < ApplicationController
  before_action -> { authorize_user!(%w[Admin]) }, except: [:index, :available_rooms, :search]
  before_action :set_hostel, only: [:index, :create]
  before_action :set_room, only: [:update, :destroy]

  def index
    rooms = @hostel.rooms
    if rooms.empty?
      render json: { message: 'No rooms found' }, status: :ok
    else
      render json: rooms, each_serializer: RoomSerializer, status: :ok
    end
  end

  def create
    room = @hostel.rooms.new(room_params)
    if room.save
      render json: room, serializer: RoomSerializer, status: :created
    else
      render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @room.update(room_params)
      render json: @room, serializer: RoomSerializer, status: :ok
    else
      render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    render json: { message: 'Room deleted successfully.' }, status: :ok
  end

  def search
    rooms = Room.all
    rooms = rooms.where('capacity >= ?', params[:capacity]) if params[:capacity].present?
    rooms = rooms.where('price <= ?', params[:price]) if params[:price].present?
    rooms = rooms.where(available: true) if params[:available] == 'true'
    if rooms.empty?
      render json: { message: 'No rooms found' }, status: :ok
    else
      render json: rooms, each_serializer: RoomSerializer, status: :ok
    end
  end

  private

  def set_hostel
    @hostel = Hostel.find(params[:hostel_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Hostel not found.' }, status: :not_found
  end

  def set_room
    @room = Room.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Room not found.' }, status: :not_found
  end

  def room_params
    params.require(:room).permit(:number, :capacity, :price, :available)
  end
end
