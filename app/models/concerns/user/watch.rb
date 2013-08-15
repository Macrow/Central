# -*- encoding : utf-8 -*-
class User
  module Watch
    extend ActiveSupport::Concern
    include ActionView::Helpers::UrlHelper
    
    included do
      has_many :watching_relationships, class_name: 'Relationship', foreign_key: 'watching_id'
      has_many :watchers,  through: :watching_relationships
      has_many :watcher_relationships, class_name: 'Relationship', foreign_key: 'watcher_id'
      has_many :watchings, through: :watcher_relationships
    end
    
    def watching(user)
      watchings << user if user.name != name
      user.notifications.create(content: "#{link_to name, "/users/#{id}"} 于 #{Time.zone.now.to_s(:db)} 对您进行了关注")
    end
  
    def not_watching(user)
      watchings.delete(user)
      user.notifications.create(content: "#{link_to name, "/users/#{id}"} 于 #{Time.zone.now.to_s(:db)} 取消了对您的关注")
    end
  
    def watching?(user)
      watchings.include?(user)
    end
    
  end
end
