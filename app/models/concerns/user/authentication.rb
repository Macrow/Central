# -*- encoding : utf-8 -*-
class User
  module Authentication
    extend ActiveSupport::Concern
  
    included do
      attr_accessor :login, :remember, :password_origin, :captcha
      has_secure_password validations: false
      before_create { generate_token(:auth_token) }
      before_create :save_login_info_after_create # set in before_create callback, for less db query
    end
    
    def update_password(attributes)
      if authenticate(attributes[:password_origin])
        update_password_without_authenticate(attributes)
      else
        errors.add(:password_origin)
        false
      end
    end
  
    def update_password_without_authenticate(attributes)
      if attributes[:password] == '' && attributes[:password_confirmation] == ''
        errors.add(:password)
        false
      else
        update_attributes(attributes)
      end
    end
  
    def authenticate_with_login
      if login.empty?
        errors.add(:login, '未输入登录名称！')
        nil
      else
        user = User.find_by_name_or_email(login)
        if user.present? && user.authenticate(password)
          user.last_login_ip = self.last_login_ip
          user.last_login_at = Time.zone.now
          user.activate
          user.auth_token
        else
          if user.present?
            errors.add(:password, '登录密码错误！')
          else
            errors.add(:login, '该用户尚未注册！')
          end
          nil
        end
      end
    end
    
    private
    
    def generate_token(column, length = 30)
      begin
        self[column] = SecureRandom.urlsafe_base64(length)
      end while User.exists?(column => self[column])
    end
    
    def save_login_info_after_create
      self.last_activity_at = self.last_activity_count_at = self.last_login_at = Time.zone.now
      self.last_login_ip = register_ip
    end
  
    module ClassMethods
      def find_by_name_or_email(login)
        where('name = ? OR email = ?', login, login).first
      end
    
      def from_omniauth(auth)
        where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
      end
    
      def create_from_omniauth(auth)
        user = User.new
        user.provider = auth['provider']
        user.uid = auth['uid']
        user.name = auth['info']['nickname']
        user.email = auth['info']['email']
        user.save(validate: false)
        user
      end
    end
  end
end
