# -*- encoding : utf-8 -*-
class PasswordResetsController < ApplicationController  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params.require(:user).permit(:email))
    user = User.where(email: @user.email).first
    if user
      user.send_password_reset_email # FIXME: need delay something
      redirect_to root_path, notice: '密码重置邮件已经发送！'
    else
      @user.errors.add(:email, '无法核实您的邮箱地址，请确认是否用该邮件地址注册！')
      flash.now[:error] = '发生错误！'
      render 'new'
    end
  end
  
  def edit
    @user = User.where(password_reset_token: params.require(:id)).first
    redirect_to root_path unless @user
  end
  
  def update
    @user = User.where(params.require(:user).permit(:password_reset_token)).first
    if @user && @user.can_reset_password?
      if @user.update_password_without_authenticate(params.require(:user).permit(:password, :password_confirmation))
        redirect_to root_path, notice: '密码重置成功！请用新密码登陆'
      else
        flash.now[:error] = '发生错误！'
        render 'edit'
      end
    else
      redirect_to root_path, notice: '密码重置时间过期发生错误或发生错误，请重新申请发送重置密码邮件！'
    end
  end
end
