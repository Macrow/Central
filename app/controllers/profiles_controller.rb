# -*- encoding : utf-8 -*-
class ProfilesController < ApplicationController
  before_action :authorize
  
  def show
  end
  
  def edit
  end
  
  def update
    if current_user.update_attributes(user_params)
      redirect_to profile_path, notice: '更新个人资料成功！'
    else
      flash.now[:error] = '发生错误！'
      render 'edit'
    end
  end
  
  def tags
    @tags = Tag.order('id DESC').each { |tag| tag.tagged = true if current_user.tag_names.map(&:name).include?(tag.name) }
  end
  
  def edit_avatar
  end

  def crop_avatar
    redirect_to profile_path, notice: '您还没有上传头像！' unless current_user.avatar.url.present?
  end
  
  def update_avatar
    if params[:user].present? && current_user.update_attributes(user_params)
      if params[:cropping_avatar]
        redirect_to profile_path, notice: '头像更新成功！'
      else
        redirect_to crop_avatar_path, notice: '如果您对头像位置不太满意，您还可以进一步请选择头像区域！'
      end
    else
      current_user.errors.add(:avatar, '没有选择文件')
      flash.now[:error] = '发生错误！'
      render 'edit_avatar'
    end
  end
  
  def edit_password
  end
  
  def update_password
    if current_user.update_password(user_params)
      redirect_to profile_path, notice: '更新密码成功！'
    else
      flash.now[:error] = '发生错误！'
      render 'edit_password'
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit!
  end
end
