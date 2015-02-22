require 'rails_helper'

describe V1::UsersController do
  describe '#create' do
    let(:email)       { 'test@example.com' }
    let(:password)    { 'Password1' }
    let(:user_params) { { email: email, password: password } }

    context 'when both password and password confirmation are provided' do
      before { post '/v1/users', user_params.merge({ password_confirmation: password }) }

      context 'and they match' do
        it 'the request is successful' do
          expect(response).to be_success
        end

        it 'returns a JWT for the newly created user' do
          returned_token = JSON.parse(response.body)['token']
          expect(returned_token.blank?).to eq false
        end
      end

      context 'but they do not match' do
        it 'a 422 unprocessable entity is returned' do
          post '/v1/users', user_params.merge({ password_confirmation: "#{password}!" })
          expect(response.status).to eq 422
        end
      end
    end

    context 'when only the password is provided' do
      before { post '/v1/users', user_params }

      it 'the request is successful' do
        expect(response).to be_success
      end

      it 'returns a JWT for the newly created user' do
        returned_token = JSON.parse(response.body)['token']
        expect(returned_token.blank?).to eq false
      end
    end

    context 'when the password is not provided' do
      it 'a 422 unprocessable entity is returned' do
        post '/v1/users', { email: email }
        expect(response.status).to eq 422
      end
    end
  end

  describe '#update' do
    let(:original_user) { FactoryGirl.create(:user) }
    let(:other_user)    { FactoryGirl.create(:user) }
    let(:jwt)           { AuthToken.issue_token({ user_id: original_user.id }) }

    context 'when the request comes from the original user' do
      context 'and the email for the user is updated' do
        context 'and the email is valid' do
          it 'the request is successful' do
            put "/v1/users/#{original_user.id}", {email: 'valid_email@example.com'}, {'Authorization' => "Bearer #{jwt}"}
            expect(response).to be_success
          end
        end

        context 'but the email is invalid' do
          it 'a 422 unprocessable entity is returned' do
            put "/v1/users/#{original_user.id}", {email: 'invalid_email'}, {'Authorization' => "Bearer #{jwt}"}
            expect(response.status).to eq 422
          end
        end
      end

      context 'and the password for the user is updated' do
        context 'and the password is valid' do
          it 'the request is successful' do
            put "/v1/users/#{original_user.id}", {password: 'ValidPassword1'}, {'Authorization' => "Bearer #{jwt}"}
            expect(response).to be_success
          end
        end

        context 'but the password is invalid' do
          it 'a 422 unprocessable entity is returned' do
            put "/v1/users/#{original_user.id}", {password: 'asd'}, {'Authorization' => "Bearer #{jwt}"}
            expect(response.status).to eq 422
          end
        end
      end
    end

    context 'when the request comes from a different user than the original' do
      it 'a 403 forbidden is returned' do
        put "/v1/users/#{other_user.id}", {email: 'new_email@example.com'}, {'Authorization' => "Bearer #{jwt}"}
        expect(response.status).to eq 403
      end
    end

    context 'when the request comes unauthorized' do
      it 'a 403 forbidden is returned' do
        put "/v1/users/#{other_user.id}", {email: 'new_email@example.com'}
        expect(response.status).to eq 403
      end
    end
  end
end
