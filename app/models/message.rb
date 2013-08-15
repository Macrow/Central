# -*- encoding : utf-8 -*-
class Message < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  attr_accessor :receiver_names, :receiver_name, :send_to_all, :users_to_send
  validates_presence_of :title, :content
  before_validation :update_users_to_send
  
  belongs_to :user
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_ids_string' # trick for eager loading
  
  scope :unread, -> { where(read: false) }
  scope :inbox, -> { where(inbox: true) }
  scope :outbox, -> { where(inbox: false) }
  default_scope { order('id DESC') }
      
  def read_once
    update_attribute(:read, true)
  end

  def receivers # trick for eager loading
    if group_send?
      User.where(id: receiver_ids_string.split(','))
    else
      [receiver]
    end
  end
  
  def receivers=(users)
    self.receiver_ids_string = users.map(&:id).join(',')
  end
  
  def inbox?
    inbox
  end
  
  def group_send?
    receiver_ids_string.include?(',')
  end
  
  def status
    if inbox?
      '收件'
    elsif group_send?
      '群发'
    else
      '发件'
    end
  end
    
  def save_and_send
    self.sender = user
    self.read = true
    transaction do
      users_to_send.each { |u| send_msg(u) } if save
    end
  end
  
  def self.group_destroy(ids)
    transaction do
      destroy_all(id: ids)
    end
  end
  
  private
  
  def update_users_to_send
    if send_to_all == '1' # send to all
      self.users_to_send = User.all.to_a
      self.users_to_send.delete(user)
      self.receivers = users_to_send
    elsif receiver_names # group send
      errors.add(:receiver_names, '请填写收件人') and return if receiver_names.empty?      
      self.users_to_send = receiver_names.split(' ').map { |name| User.where(name: name).first }
      self.users_to_send.delete(nil)
      errors.add(:receiver_names, '收件人未找到') and return if users_to_send.empty?
      self.receivers = users_to_send
    else # single send
      unless receiver_ids_string # skip for send_msg
        errors.add(:receiver_name, '请填写收件人') and return if receiver_name.nil? || receiver_name.empty?
        receiver = User.where(name: receiver_name).first
        errors.add(:receiver_name, '收件人未找到') and return if receiver.nil?
        self.users_to_send = [receiver]
        self.receivers = [receiver]
      end
    end
  end
  
  def send_msg(receiver)
    new_msg = Message.new(title: title, content: content, inbox: true)
    new_msg.sender = sender
    new_msg.receivers = [receiver]
    new_msg.user = receiver
    new_msg.save!
    receiver.notifications.build(content: "#{link_to user.name, "/users/#{user.id}"} 于 #{Time.zone.now.to_s(:db)} 给您发送了一条#{link_to '短信', "/messages/#{new_msg.id}"}。").save
  end
end
