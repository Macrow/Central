# -*- encoding : utf-8 -*-
class User
  module Active
    extend ActiveSupport::Concern
    
    included do
      ACTIVITY_COUNT_TIME = 5.hours
      ONLINE_COUNT_TIME = 10.minutes
    end
    
    def activate
      current_time = Time.zone.now
      self.last_activity_at = current_time
      if current_time > last_activity_count_at + ACTIVITY_COUNT_TIME
        self.activity_count = activity_count + 1
        self.last_activity_count_at = current_time
      end
      save
    end
    
    module ClassMethods
      def active_users(minutes = ONLINE_COUNT_TIME)
        where("last_activity_at > ?", minutes.ago)
      end
    end
  end
end
