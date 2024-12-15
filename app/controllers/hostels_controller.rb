class HostelsController < ApplicationController
  before_action -> { authorize_user!(%w[Admin]) }, except: [:index]
  before_action :set_hostel, only: [:update, :destroy]

  def index
    hostels = Hostel.all
    if hostels.empty?
      render json: { message: 'No hostels found' }, status: :ok
    else
      render json: hostels, each_serializer: HostelSerializer, status: :ok
    end
  end

  def create
    hostel = current_user.hostels.new(hostel_params) # Ensure admin association
    if hostel.save
      render json: hostel, serializer: HostelSerializer, status: :created
    else
      render json: { errors: hostel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @hostel.update(hostel_params)
      render json: @hostel, serializer: HostelSerializer, status: :ok
    else
      render json: { errors: @hostel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @hostel.destroy
    render json: { message: 'Hostel deleted successfully.' }, status: :ok
  end

  private

  def set_hostel
    @hostel = current_user.hostels.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Hostel not found.' }, status: :not_found
  end

  def hostel_params
    params.require(:hostel).permit(:name, :address, :city, :state, :country, :pincode)
  end
end