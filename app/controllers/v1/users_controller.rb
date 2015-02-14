class V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      token = issue_new_token_for(user)
      render json: { user: user, token: token }, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    jwt = parse_and_validate_jwt
    if jwt && jwt.first['user_id'] == params[:id].to_i
      user = User.find(params[:id])
      if user.update_attributes(user_params)
        token = issue_new_token_for(user)
        render json: { user: user, token: token }, status: 200
      else
        render json: { errors: user.errors }, status: 422
      end
    else
      return head :forbidden
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def issue_new_token_for(user)
    AuthToken.issue_token({ user_id: user.id })
  end
end
