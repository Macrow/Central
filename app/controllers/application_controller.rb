# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout
  before_action :save_user_activity_status
  after_action :reset_last_captcha_code! # reset captcha code after each request for security
  helper_method :current_user, :active_users, :captcha_on?, :current_page, :unread_messages_count, :unread_notifications_count

  protected
  
  def current_user
    @current_user ||= User.where(auth_token: cookies[:auth_token]).first if cookies[:auth_token]
  end
  
  def unread_messages_count
    @unread_messages_count ||= current_user.messages.inbox.unread.count
  end
  
  def unread_notifications_count
    @unread_notifications_count ||= current_user.notifications.unread.count
  end
  
  def increase_fail_count
    session[:fail_count] = 1 + (session[:fail_count] || 0)
  end
  
  def reset_fail_count
    session[:fail_count] = 0
  end
    
  def check_captcha_valid(model)
    if !captcha_on?
      true
    elsif captcha_valid?(model.captcha)
      true
    else
      model.errors.add(:captcha, '验证码错误！')
      model.captcha = ''
      false
    end
  end
  
  def per_page_count
    Settings.per_page_count.to_i
  end
  
  private
  
  def set_layout
    current_user ? 'application' : 'not_login'
  end
  
  def authorize
    redirect_to root_path, notice: '操作前请登录！' unless current_user
  end
  
  def save_user_activity_status
    current_user.try(:activate)
  end
  
  def captcha_on?
    captcha_on = Settings.captcha_on == 1 ? true : false
    fail_count = Settings.fail_count
    captcha_on || ((session[:fail_count] || 0).to_i >= fail_count.to_i)
  end
  
  def active_users
    User.active_users
  end
  
  def current_page
    @current_page ||= ((params[:page].nil? ? 1 : params[:page].to_i) - 1) * per_page_count
  end
end
