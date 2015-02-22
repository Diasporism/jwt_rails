require 'rails_helper'

describe V1::SessionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:correct_user_params) {
    {
        user: {
            email: user.email,
            password: user.password
        }
    }
  }
  let(:incorrect_user_params) {
    {
        user: {
            email: "incorrect #{user.email}",
            password: "incorrect #{user.password}"
        }
    }
  }

  describe '#create' do
    context 'when the user logs in with correct credentials' do
      before { post '/v1/login', correct_user_params }

      it 'the request is successful' do
        expect(response).to be_success
      end

      it 'returns a JWT for the authenticated user' do
        returned_token = JSON.parse(response.body)['token']
        expect(returned_token.blank?).to eq false
      end
    end

    context 'when the user attempts to log in with incorrect credentials' do
      before { post '/v1/login', incorrect_user_params }

      it 'a 422 unprocessable entity is returned' do
        expect(response.status).to eq 422
      end

      it 'an error message stating the username or password did not match is returned' do
        error_message = JSON.parse(response.body)['errors']
        expect(error_message).to eq 'username or password did not match'
      end
    end
  end

  describe '#authorize' do
    let(:valid_jwt)   { AuthToken.issue_token({ user_id: user.id }) }
    let(:invalid_jwt) { 'garbage.and.invalid_jwt' }

    context 'when the user has a valid JWT' do
      before { get 'v1/authorize', {}, {'Authorization' => "Bearer #{valid_jwt}"} }

      it 'the request is successful' do
        expect(response).to be_success
      end

      it 'returns a JWT for the authenticated user' do
        returned_token = JSON.parse(response.body)['token']
        expect(returned_token.blank?).to eq false
      end

      it "returns the user's id from the JWT so the client can perform matches against it" do
        user_id = JSON.parse(response.body)['user']['id']
        expect(user_id).to eq user.id
      end
    end

    context 'when the user has an invalid JWT' do
      it 'a 403 forbidden is returned' do
        get 'v1/authorize', {}, {'Authorization' => "Bearer #{invalid_jwt}"}
        expect(response.status).to eq 403
      end
    end
  end
end
