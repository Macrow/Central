# -*- encoding : utf-8 -*-
class Score
  include ActiveModel::Model
  attr_accessor :receiver_names, :receivers, :score, :send_to_all
  
  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end
    
  def save
    update_scores
  end
  
  def reset
    update_scores(reset: true)
  end
  
  def persisted?
    false
  end
  
  private
  
  def update_scores(options = {})
    errors.add(:score, '请填写积分数') and return false if score.nil? || score.empty?
    errors.add(:score, '积分必须是数字') and return false if (score =~ /^(\+|-)?\d+$/).nil?
    if send_to_all == '1' # send to all
      self.receivers = User.all
      return User.update_all_score(score) if options[:reset]
    else # group send or single send
      errors.add(:receiver_names, '请填写接收人') and return false if receiver_names.nil? || receiver_names.empty?      
      self.receivers = receiver_names.split(' ').map { |name| User.where(name: name).first }
      self.receivers.delete(nil)
      errors.add(:receiver_names, '收件人未找到') and return false if receivers.empty?
    end
    receivers.each do |user|
      if options[:reset]
        user.reset_score(score.to_i)
      else
        user.update_score(score.to_i)
      end
    end
  end
end
