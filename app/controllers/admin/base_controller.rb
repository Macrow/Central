# -*- encoding : utf-8 -*-
module Admin
  class BaseController < ::ApplicationController
    layout 'admin'
    before_filter :authorize_admin
  
    private
  
    def authorize_admin
      redirect_to root_path, notice: '仅允许管理员进行操作！' unless current_user && current_user.admin
    end
  end
end
