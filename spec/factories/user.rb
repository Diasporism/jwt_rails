FactoryGirl.define do
  factory :user do
    email    { Forgery('email').address }
    password 'Password1'
  end
end
