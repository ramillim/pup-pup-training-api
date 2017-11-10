FactoryBot.define do
  factory :user do
    email { SecureRandom.uuid + '@foobar.com' }
    password 'abcd1234'
  end
end
