# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    short_url { SecureRandom.alphanumeric(5).upcase }
    sequence(:original_url) { |i| "https://domain#{i}.com/path" }
  end
end
