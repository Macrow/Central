# -*- encoding : utf-8 -*-
class MessagesController < ApplicationController
  before_action :authorize
  
  def index
    @messages = current_user.messages.inbox.includes(:sender).page(params[:page]).per_page(per_page_count)
  end
  
  def unread
    @messages = current_user.messages.inbox.unread.includes(:sender).page(params[:page]).per_page(per_page_count)
    render 'index'    
  end
  
  def outbox
    @messages = current_user.messages.outbox.includes(:sender).page(params[:page]).per_page(per_page_count)
    render 'index'
  end
  
  def new
    @message = Message.new(receiver_name: params[:receiver_name])
    @message.receiver_name = params[:receiver_name]
  end
  
  def create
    @message = current_user.messages.build(message_params)
    if @message.save_and_send
      redirect_to profile_path, notice: '消息发送成功！'
    else
      flash.now[:error] = '发生错误！'
      render 'new'
    end
  end
  
  def show
    @message = current_user.messages.where(id: params[:id]).first
    @message.try(:read_once)
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end
  
  def group_destroy
    @ids = params[:submit_ids].split(',')
    Message.group_destroy(@ids)
  end
  
  private
  
  def message_params
    params.require(:message).permit(:receiver_name, :title, :content)
  end
end
