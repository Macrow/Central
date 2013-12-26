# -*- encoding : utf-8 -*-
module Admin
  class MessagesController < BaseController
    def index
      @q = Message.unscoped.search(params[:q])
      @messages = @q.result.includes(:sender, :receiver).order('id DESC').page(params[:page]).per_page(per_page_count)
    end

    def show
      @message = Message.find(params[:id])
    end
    
    def new
      @message = Message.new
    end
        
    def create
      @message = current_user.messages.build(message_params)
      if @message.save_and_send
        redirect_to admin_messages_path, success: '短信发送成功！'
      else
        flash.now[:danger] = '发生错误！'
        render 'new'
      end
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
      params.require(:message).permit!
    end
  end
end
