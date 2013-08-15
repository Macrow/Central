# -*- encoding : utf-8 -*-
class User
  module UserGroup
    extend ActiveSupport::Concern
    
    included do
      has_and_belongs_to_many :groups
    end
    
    module ClassMethods
      def group_destroy(ids)
        transaction do
          destroy_all(id: ids)
        end
      end
    end
  end
end
