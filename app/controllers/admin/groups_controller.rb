# -*- encoding : utf-8 -*-
module Admin
  class GroupsController < BaseController
    def index
      @q = Group.search(params[:q])
      @groups = @q.result.page(params[:page]).per_page(per_page_count)
    end
    
    def new
      @group = Group.new
    end
    
    def create
      @group = Group.new
      @group.assign_attributes(params.require(:group).permit!)
      if @group.save
        redirect_to admin_groups_path, success: '用户组创建成功！'
      else
        flash.now[:danger] = '发生错误！'
        render 'new'
      end
    end
    
    def show
      @group = Group.find(params[:id])
      @q = @group.users.search(params[:q])
      @users = @q.result.page(params[:page]).per_page(per_page_count)
    end
        
    def edit
      @group = Group.find(params[:id])
      @groups = Group.all
    end
    
    def update
      @group = Group.find(params[:id])
      if @group.update_attributes(params.require(:group).permit!)
        redirect_to admin_groups_path, notice: '用户组信息更新成功！'
      else
        flash.now[:danger] = '发生错误！'
        render 'edit'
      end
    end
    
    def destroy
      @group = Group.find(params[:id])
      @group.destroy
    end
  end
end
