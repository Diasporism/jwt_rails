require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it 'is a valid ActiveRecord model' do
    expect(user).to be
  end
end
