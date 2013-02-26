# -*- encoding : utf-8 -*-
module Admin
  class TagsController < BaseController
    def index
      @user_tags = User.tag_counts_on(:tags).all
      @tags = Tag.all.each { |tag| tag.tagged = true if @user_tags.map(&:name).include?(tag.name) }
      @tags.sort_by!(&:name)
    end
    
    def show
      @tag = Tag.find(params[:id])
      @q = User.tagged_with(@tag.name).search(params[:q])
      @users = @q.result.page(params[:page]).per_page(per_page_count)
    end
    
    def new
      @tag = Tag.new
    end
    
    # create.js.haml
    def create
      @tag = Tag.new(params[:tag])
      @tag.save
    end
    
    def destroy
      @tag = Tag.find(params[:id])
      @tag.destroy
    end
  end
end
