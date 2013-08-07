# -*- encoding : utf-8 -*-
module Admin
  class NotificationsController < BaseController
    def index
      @q = Notification.unscoped.search(params[:q])
      @notifications = @q.result.includes(:user).order('id DESC').page(params[:page]).per_page(per_page_count)
    end

    def show
      @notification = Notification.find(params[:id])
    end
    
    def new
      @notification = Notification.new
    end
    
    def create
      @notification = current_user.notifications.build(params.require(:notification).permit!)
      if @notification.send_notifications
        redirect_to admin_notifications_path, notice: '提醒发送成功！'
      else
        flash.now[:error] = '发生错误！'
        render 'new'
      end
    end

    def destroy
      @notification = Notification.find(params[:id])
      @notification.destroy
    end
    
    def group_destroy
      @ids = params[:submit_ids].split(',')
      Notification.group_destroy(@ids)
    end
  end
end
