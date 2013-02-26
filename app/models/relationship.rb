# -*- encoding : utf-8 -*-
class Relationship < ActiveRecord::Base
  belongs_to :watching, :class_name => 'User', :foreign_key => "watching_id"
  belongs_to :watcher,  :class_name => 'User', :foreign_key => "watcher_id"
end
