# -*- encoding : utf-8 -*-
class NotificationsController < ApplicationController
  before_filter :authorize
  
  def index
    @notifications = current_user.notifications.read.page(params[:page]).per_page(per_page_count)
  end
  
  def unread
    @notifications = current_user.notifications.unread.page(params[:page]).per_page(per_page_count)
    Notification.read_all(current_user.id, @notifications.map(&:id)) if @notifications.length > 0
    render 'index'
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
