# -*- encoding : utf-8 -*-
module Admin
  class ScoresController < BaseController
    def new
      @score = Score.new
    end
    
    def create
      @score = Score.new(params[:score])
      if @score.save
        redirect_to admin_users_path, notice: '积分发放成功！'
      else
        flash.now[:error] = '发生错误！'
        render 'new'
      end
    end
    
    def reset
      @score = Score.new
    end
    
    def do_reset
      @score = Score.new(params[:score])
      if @score.reset
        redirect_to admin_users_path, notice: '积分重置成功！'
      else
        flash.now[:error] = '发生错误！'
        render 'reset'
      end
    end
  end
end
