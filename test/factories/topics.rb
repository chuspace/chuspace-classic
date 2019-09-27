FactoryBot.define do
  factory :topic do
    name { %w[rails ruby javascript webpack rust crystal].sample }
  end
end
