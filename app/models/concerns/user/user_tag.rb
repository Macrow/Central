# -*- encoding : utf-8 -*-
class User
  module UserTag
    extend ActiveSupport::Concern
    
    included do
      acts_as_taggable
      TAG_SPLITTER = '#$@'
    end
    
    # 目的是为了减少 acts-as-taggable-on 查询数据库的次数，因为本身要用到 tags 方法进行查询
    def tag_text=(text)
      tag_array = text.split(TAG_SPLITTER)
      tag_array.delete('')
      self.tag_list = tag_array.compact
    end
  
    def tag_text
      tag_list.join(TAG_SPLITTER)
    end
  
    def tag_names
      tag_list.map { |tag| Tag.new(name: tag, tagged: true) }
    end
    
  end
end
