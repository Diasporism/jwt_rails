class ApplicationController < ActionController::Base
  require 'auth_token'

  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  respond_to :json

  private

  def not_found
    return head :not_found
  end

  def parse_and_validate_jwt
    jwt = request.headers['Authorization']
    if jwt
      jwt.gsub!(/^Bearer /, '')
      AuthToken.valid?(jwt)
    else
      false
    end
  end

  def issue_new_token_for(user)
    AuthToken.issue_token({ user_id: user.id })
  end
end
