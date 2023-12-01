class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::RequestForgeryProtection
  include Authentication

  protect_from_forgery with: :exception

  def not_found
    render json: { error: 'not found' }, status: :not_found
  end
end
