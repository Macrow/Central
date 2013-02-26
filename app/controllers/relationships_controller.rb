# -*- encoding : utf-8 -*-
class RelationshipsController < ApplicationController
  before_filter :authorize
  
  def create
    @user = User.find(params[:id])
    current_user.watching(@user)
  end
  
  def destroy
    @user = User.find(params[:id])    
    current_user.not_watching(@user)
    render 'create'
  end
end
