class UsersController < ApplicationController
  def create
    @user = User.find_or_create_by name: params_user[:name]

    session[:user_id] = @user.id

    redirect_to root_path
  end

  def destroy
    logout

    redirect_to root_path
  end

  private
    def params_user
      params.required(:user).permit :name
    end
end
