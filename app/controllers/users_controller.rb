class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:logout]
  before_action :validate_user_type, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created, serializer: UserSerializer
    else
      render json: { message: 'User creation failed.', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      token = Auth::JsonWebToken.encode(user: user.id)
      render json: { message: 'Login successful.', token: token, user: UserSerializer.new(user) }, status: :ok
    else
      render json: { message: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def logout
    if @current_user
      JwtDenylist.create!(jti: @decoded_token[:jti], exp: Time.at(@decoded_token[:exp]))
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { message: 'Unauthorized.' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :type)
  end

  def jwt_payload
    Auth::JsonWebToken.decode(request.headers['Authorization']&.split&.last)
  rescue
    {}
  end

  def validate_user_type
    valid_types = User.valid_types
    unless valid_types.include?(params[:user][:type])
      render json: { message: "Invalid user type. Valid types are: #{valid_types.join(', ')}." }, status: :unprocessable_entity
    end
  end
end
