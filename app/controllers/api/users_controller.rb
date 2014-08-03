class API::UsersController < API::BaseController
  skip_before_filter :authenticate, only: [:create]

  # GET /api/users/current
  def current
    @user = current_user
    respond_with @user
  end

  # POST /api/users
  def create
    if (_user_params[:nickname] && _user_params[:nickname].length > 1)
      # nickname is not a real field. only a spam catcher
      return forbidden()
    end
    user = User.new(_user_params.except(:nickname)) # nickname is not a real field. only a spam catcher
    if user.save
      access_token = current_access_token
      access_token.user = user
      render json: {
          token: access_token.token,
          message: { type: SUCCESS, content: "User created for #{access_token.user.email}. Kick some booty!" }
      }
    else
      error(user.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  # PUT api/users/current
  def update
    if current_user.update(_user_params.except(:email)) # no changing email at the moment
      render json: { message: { type: SUCCESS, content: 'User has been updated' } }, status: :ok
    else
      error(current_user.errors.full_messages.join(', '), WARNING, :unprocessable_entity)
    end
  end

  private

    def _user_params
      params.require(:user).permit(:first_name, :last_name, :nickname, :email, :password, :password_confirmation)
    end

end
