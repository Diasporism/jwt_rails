class V1::SessionsController < ApplicationController
  def create
    user = User.where(email: params[:user][:email]).first
    if user && user.authenticate(params[:user][:password])
      token = issue_new_token_for(user)
      render json: { user: { id: user.id, email: user.email }, token: token }, status: 200
    else
      render json: { errors: 'username or password did not match' }, status: 422
    end
  end

  def authorize
    valid_token = parse_and_validate_jwt
    if valid_token
      user = User.find(valid_token.first['user_id'])
      render json: { user: { id: user.id, email: user.email }, token: issue_new_token_for(user) }, status: 200
    else
      return head :forbidden
    end
  end
end
