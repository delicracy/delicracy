FactoryBot.define do
  factory :offer do
    user
    lane
    lot 100
    kind "IN"

    factory :offer_out do
      kind "OUT"
    end
  end
end

