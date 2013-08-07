# -*- encoding : utf-8 -*-
class Notification < ActiveRecord::Base
  attr_accessor :receiver_names, :send_to_all, :receivers
  belongs_to :user
  before_validation :update_users_to_send
  validates_presence_of :content
  
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  default_scope { order('id DESC') }
  
  def send_notifications
    if valid?
      transaction do
        receivers.each { |u| u.notifications.create(content: content) }
      end
    else
      false
    end
  end
  
  class << self
    def read_all(user_id, ids)
      where(user_id: user_id, id: ids).update_all(read: true)
    end
    
    def group_destroy(ids)
      transaction do
        destroy_all(id: ids)
      end
    end
  end
  
  private
  
  def update_users_to_send
    if send_to_all == '1' # send to all
      self.receivers = User.all.to_a
      self.receivers.delete(user)
    elsif receiver_names # group send or single send
      errors.add(:receiver_names, '请填写接收人') and return if receiver_names.empty?      
      self.receivers = receiver_names.split(' ').map { |name| User.where(name: name).first }
      self.receivers.delete(nil)
      errors.add(:receiver_names, '接收人未找到') and return if receivers.empty?
    end
  end
  
end
