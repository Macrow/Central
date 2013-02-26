# -*- encoding : utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: Settings.admin_email || "from@example.com"

  def register_confirmation(user)
    @user = user
    mail to: @user.email, subject: '欢迎注册'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: '重置密码'
  end
end
