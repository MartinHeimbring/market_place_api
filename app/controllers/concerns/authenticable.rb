module Authenticable

  # Devise methods overwrite

  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def request
    request
  end

  def response
    response
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless user_signed_in?
  end

end