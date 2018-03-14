FactoryBot.define do
  factory :race do
    title "Example Race"
    description "This is a example race."
    category
    rule Race::WINNER_TAKES_ALL
    association :host, factory: :john

    factory :race_with_lanes do
      transient do
        lanes_count 4
      end
      
      after(:create) do |race, evaluator|
        create_list(:lane, evaluator.lanes_count, race: race)
      end
    end
  end
end

