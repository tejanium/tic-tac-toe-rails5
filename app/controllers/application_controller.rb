class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  protected
    def logout
      session[:user_id] = nil
    end

    def current_user
      return unless session[:user_id]

      @current_user ||= User.find session[:user_id]
    rescue ActiveRecord::RecordNotFound => e
      logout
    end
end
