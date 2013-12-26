# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.new(name: 'admin', email: 'admin@email.com', password: '123456', password_confirmation: '123456')
admin.admin = true
admin.save!

require 'SecureRandom'

(1..120).each do
  User.create!(name: "#{SecureRandom.hex.to_s.slice(0, 5)}", email: "#{SecureRandom.hex.to_s.slice(0, 5)}@yeah.net", password: '123456', password_confirmation: '123456')
end
