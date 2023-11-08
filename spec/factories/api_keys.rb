FactoryBot.define do
  factory :api_key do
    access_token { Faker::Stripe.valid_token }
  end
end
