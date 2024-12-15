module AuthHelper
  private

  def authenticate_user!
    token = request.headers['Authorization']&.split&.last

    begin
      @decoded_token = Auth::JsonWebToken.decode(token)
      @current_user = User.find_by(id: @decoded_token[:user])

      render json: { message: 'Unauthorized or invalid token.' }, status: :unauthorized unless @current_user
    rescue JWT::ExpiredSignature
      render json: { message: 'Token has expired.' }, status: :unauthorized
    rescue JWT::DecodeError, StandardError
      render json: { message: 'Invalid token.' }, status: :unauthorized
    end
  end

  def decode_jwt(token)
    return nil if token.blank?

    Auth::JsonWebToken.decode(token)
  rescue JWT::DecodeError, StandardError
    nil
  end

  def current_user
    @current_user
  end
end
