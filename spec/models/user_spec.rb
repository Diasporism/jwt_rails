require 'rails_helper'

describe User do
  describe User do
    describe 'Validations' do
      context 'on a new user' do
        it 'should not be valid without a password' do
          user = User.new password: nil, password_confirmation: nil
          expect(user).to_not be_valid
        end

        it 'should not be valid with an empty password' do
          user = User.new password: '', password_confirmation: ''
          expect(user).to_not be_valid
        end

        it 'should be not be valid with a short password' do
          user = User.new password: 'short', password_confirmation: 'short'
          expect(user).to_not be_valid
        end

        it 'should not be valid with a confirmation mismatch' do
          user = User.new password: 'one thing', password_confirmation: 'another thing'
          expect(user).to_not be_valid
        end
      end

      context 'on an existing user' do
        let(:user) do
          user = FactoryGirl.create(:user)
          User.find(user.id) #Reload user to remove cached password attribute
        end

        it 'should be valid with no changes' do
          expect(user).to be_valid
        end

        it 'should be able to update the record without changing the password' do
          user.email = 'new_email@example.com'
          expect(user).to be_valid
        end

        it 'should not update the password if it is set to an empty string' do
          old_password_digest = user.password_digest
          user.password = ''
          user.save
          expect(user.reload.password_digest).to eq old_password_digest
        end

        it 'should be valid with a new (valid) password' do
          user.password = user.password_confirmation = 'new password'
          expect(user).to be_valid
        end

        it 'should be valid with a new (valid) email' do
          user.email = 'test@example.com'
          expect(user).to be_valid
        end

        it 'should not be valid with an empty email' do
          user.email = ''
          expect(user).to_not be_valid
        end

        it 'should not be valid with a new (invalid) email' do
          user.email = 'invalid email'
          expect(user).to_not be_valid
        end
      end
    end
  end
end
