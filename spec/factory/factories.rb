# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}" }
    email  { "#{name}@163.com" }
    password 'Secret'
  end
  
  factory :group do
    sequence(:name) { |n| "group-#{n}" }
  end

  factory :tag do
    sequence(:name) { |n| "tag#{n}" }
  end
  
  factory :message do
    title 'message title'
    content 'message content'
  end
end
