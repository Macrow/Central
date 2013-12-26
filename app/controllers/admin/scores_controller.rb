# -*- encoding : utf-8 -*-
module Admin
  class ScoresController < BaseController
    def new
      @score = Score.new
    end
    
    def create
      @score = Score.new(params.require(:score).permit!)
      if @score.save
        redirect_to admin_users_path, success: '积分发放成功！'
      else
        flash.now[:danger] = '发生错误！'
        render 'new'
      end
    end
    
    def reset
      @score = Score.new
    end
    
    def do_reset
      @score = Score.new(params.require(:score).permit!)
      if @score.reset
        redirect_to admin_users_path, success: '积分重置成功！'
      else
        flash.now[:danger] = '发生错误！'
        render 'reset'
      end
    end
  end
end
