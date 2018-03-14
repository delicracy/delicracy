FactoryBot.define do
  factory :user do
    name "Sample User"
    email { "#{name.parameterize}@example.com" }
    password "password"
    activated true
  end

  factory :michael, class: User do
    name "Michael"
    email "michael@example.com"
    password 'password'
    activated true
  end

  factory :john, class: User do
    name "John Doe"
    email "john@example.com"
    password 'password'
    activated true
  end

  factory :admin, class: User do
    name "Admin"
    email "admin@example.com"
    password 'password'
    activated true
    is_admin true
  end
end
