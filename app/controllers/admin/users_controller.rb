# -*- encoding : utf-8 -*-
module Admin
  class UsersController < BaseController
    before_filter :get_groups, only: [:new, :create, :edit, :update]
    
    def index
      @q = User.search(params[:q])
      @users = @q.result.order('id DESC').page(params[:page]).per_page(per_page_count)
    end
    
    def fetch
      @users = User.where(id: params[:ids].split(','))
    end
    
    def admins
      @q = User.search(params[:q])
      @users = @q.result(distinct: true).where(admin: true).page(params[:page]).per_page(per_page_count)
    end
    
    def show
      @user = User.find(params[:id])
    end
    
    def new
      @user = User.new
      @tags = Tag.order('id DESC')
    end
    
    def create
      @user = User.new
      @user.admin = params[:user].delete(:admin)
      @user.assign_attributes(params.require(:user).permit!)
      if @user.save
        redirect_to admin_users_path, notice: '用户创建成功！'
      else
        @tags = Tag.order('id DESC').each { |tag| tag.tagged = true if @user.tag_text.split(User::TAG_SPLITTER).include?(tag.name) }
        flash.now[:error] = '发生错误！'
        render 'new'
      end
    end
        
    def edit
      @user = User.find(params[:id])
      @tags = Tag.order('id DESC').each { |tag| tag.tagged = true if @user.tag_names.map(&:name).include?(tag.name) }
    end
    
    def update
      @user = User.find(params[:id])
      @user.admin = params[:user].delete(:admin)
      if params[:user][:password] == '' and params[:user][:password_confirmation] = ''
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      if @user.update_attributes(params.require(:user).permit!)
        redirect_to admin_users_path, notice: '用户信息更新成功！'
      else
        @tags = Tag.order('id DESC').each { |tag| tag.tagged = true if @user.tag_names.map(&:name).include?(tag.name) }
        flash.now[:error] = '发生错误！'
        render 'edit'
      end
    end
    
    def destroy
      @user = User.find(params[:id])
      @user.destroy
    end
    
    def group_destroy
      @ids = params[:submit_ids].split(',')
      User.group_destroy(@ids)
    end
    
    private
    
    def get_groups
      @groups = Group.all
    end
  end
end
