# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  helper_method :github_on, :qq_on, :weibo_on
  
  def new
    redirect_to root_path, notice: '您已经登陆，请不要重复登陆！' if current_user
    @user = User.new
  end
  
  def create
    @user = User.new(user_params.merge!(last_login_ip: request.ip))
    if check_captcha_valid(@user) && (auth_token = @user.authenticate_with_login)
      if @user.remember == '1'
        cookies.permanent[:auth_token] = auth_token
      else
        cookies[:auth_token] = auth_token
      end
      reset_fail_count
      redirect_to root_path, notice: '登陆成功！'
    else
      increase_fail_count
      flash.now[:error] = '发生错误！'
      render 'new'
    end
  end
  
  def create_from_omniauth
    user = User.from_omniauth(env['omniauth.auth'])
    cookies[:auth_token] = user.auth_token
    reset_fail_count
    redirect_to root_path, notice: '登陆成功！'
  end

  def destroy
    cookies.delete :auth_token
    redirect_to root_path, notice: '您已经成功退出！'
  end

  private
  
  def github_on
    Settings.sign_in_with_github == 1
  end
  
  def qq_on
    Settings.sign_in_with_qq == 1
  end
  
  def weibo_on
    Settings.sign_in_with_weibo == 1
  end
  
  def user_params
    params.require(:user).permit(:login, :password, :remember, :captcha)
  end
end
