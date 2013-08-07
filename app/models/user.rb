# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  SEX = [['保密', '保密'], ['男', '男'], ['女', '女']]
  TAG_SPLITTER = '#$@'
  ACTIVITY_COUNT_TIME = 5.hours
  ONLINE_COUNT_TIME = 10.minutes
  attr_accessor :login, :remember, :password_origin, :captcha, :crop_x, :crop_y, :crop_w, :crop_h
  validates_presence_of :name, :email, on: :create
  validates_uniqueness_of :name, :email, case_sensitive: false, on: :create
  validates_length_of :name, within: 3..10, if: lambda { |m| m.name.present? }
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  validates_presence_of :password, on: :create
  validates_presence_of :password_confirmation, if: lambda { |m| m.password.present? }
  validates_length_of :password, within: 6..20, if: lambda { |m| m.password.present? }
  validates :email, email_format: { message: '邮箱格式错误', on: :create }
  before_create :save_login_info_after_create # set in before_create callback, for less db query
  before_create { generate_token(:auth_token) }
  before_save :crop_avatar
  has_many :watching_relationships, class_name: 'Relationship', foreign_key: 'watching_id'
  has_many :watchers,  through: :watching_relationships
  has_many :watcher_relationships, class_name: 'Relationship', foreign_key: 'watcher_id'
  has_many :watchings, through: :watcher_relationships
  has_many :messages, dependent: :delete_all # without destroy on messages
  has_many :notifications, dependent: :delete_all # without destroy on notifications
  has_and_belongs_to_many :groups
  mount_uploader :avatar, AvatarUploader
  acts_as_taggable
  has_secure_password validations: false
  
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
    
  def send_password_reset_email
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def can_reset_password?
    password_reset_sent_at > 20.minutes.ago
  end

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end
  
  def avatar_url(size = :mid)
    avatar.url(size) || "#{size}_avatar.png"
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
  
  def inbox_messages
    messages.where(inbox: true)
  end
  
  def outbox_messages
    messages.where(inbox: false)
  end
  
  def update_score(num)
    begin
      update_column(:score, score + num.to_i)
      true
    rescue
      false
    end
  end

  def reset_score(num)
    begin
      update_column(:score, num.to_i)
      true
    rescue
      false
    end
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
  
  class << self
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
    
    def active_users(minutes = ONLINE_COUNT_TIME)
      where("last_activity_at > ?", minutes.ago)
    end
    
    def update_all_score(score)
      begin
        update_all(score: score.to_i)
        true
      rescue
        false
      end
    end
    
    def group_destroy(ids)
      transaction do
        destroy_all(id: ids)
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
end
