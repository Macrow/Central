# -*- encoding : utf-8 -*-
class User
  module PasswordReset
    extend ActiveSupport::Concern
    
    def send_password_reset_email
      generate_token(:password_reset_token)
      self.password_reset_sent_at = Time.zone.now
      save!
      UserMailer.password_reset(self).deliver
    end
  
    def can_reset_password?
      password_reset_sent_at > 20.minutes.ago
    end
    
    
    module ClassMethods
      
    end
  end
end
