# -*- encoding : utf-8 -*-
module Admin
  class HomeController < BaseController
    def index
      @users_count                = User.count
      @groups_count               = Group.count
      @messages_count             = Message.count
      @unread_nitofications_count = Notification.unread.count
      @tags_count                 = Tag.count
    end
    
    def edit
      
    end
    
    def update
      Settings.update_settings(params[:settings])
      redirect_to edit_admin_home_path, notice: '设置更新成功！'
    end
  end
end
