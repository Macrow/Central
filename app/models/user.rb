# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  SEX = [['保密', '保密'], ['男', '男'], ['女', '女']]
  validates_uniqueness_of :name, :email, case_sensitive: false, on: :create
  validates_length_of :name, within: 3..10, if: lambda { |m| m.name.present? }
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  validates_presence_of :name, :email, :password, on: :create
  validates_presence_of :password_confirmation, if: lambda { |m| m.password.present? }
  validates_length_of :password, within: 6..20, if: lambda { |m| m.password.present? }
  validates :email, email_format: { message: '邮箱格式错误', on: :create }
  has_many :notifications, dependent: :delete_all # without destroy on notifications
  has_many :messages, dependent: :delete_all # without destroy on messages
  
  include Authentication
  include PasswordReset
  include Watch
  include Avatar
  include UserTag
  include Score
  include Active
  include UserGroup
end
