class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # :null_session does not allow POST or PUT requests to work
  protect_from_forgery with: :null_session
end
