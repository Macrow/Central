# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def index
    render layout: 'no_profile_card'
  end
  
  def all
    @users = User.all
  end
  
  def new
    if current_user
      redirect_to root_path, info: '您已经登陆，如需注册，请退出后再作尝试。'
    else
      @user = User.new
    end
  end
  
  def create
    @user = User.new(user_params)
    if check_captcha_valid(@user) && @user.save
      reset_fail_count
      cookies[:auth_token] = @user.auth_token
      UserMailer.delay.register_confirmation(@user) if send_sign_up_email
      redirect_to root_path, success: '注册成功！您已经登陆！'
    else
      increase_fail_count
      flash.now[:danger] = '发生错误！'
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    render layout: 'not_login'
  end
  
  private
  
  def send_sign_up_email
    Settings.send_register_email == 1
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :captcha).merge!(register_ip: request.ip)
  end
end
