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
end
