class ApplicationController < ActionController::Base
  include AuthHelper
  protect_from_forgery with: :null_session
  
  before_action :authenticate_user!

  def authorize_user!(allowed_types)
    unless allowed_types.include?(current_user.type)
      render json: { error: 'Not authorized' }, status: :forbidden
    end
  end
end
