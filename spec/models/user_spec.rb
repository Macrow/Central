# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  describe "内部函数测试" do
    let(:user) { FactoryGirl.create(:user) }
    
    it "每次产生唯一的重置密码的字符串" do
      user.send_password_reset_email
      user.password_reset_token.should_not be_nil
      last_token = user.password_reset_token
      user.send_password_reset_email
      user.password_reset_token.should_not == last_token
    end
    
    it "发送重置邮件后记录发送时间" do
      user.send_password_reset_email
      user.reload.password_reset_sent_at.should be_present
    end
    
    it "发送邮件给用户" do
      user.send_password_reset_email
      last_email.to.should include(user.email)
    end
    
    it "密码重置时间超时" do
      user.send_password_reset_email
      user.password_reset_sent_at = 25.minutes.ago
      user.save!
      user.can_reset_password?.should be_false
    end
    
    it "凭借用户名称或者邮件找到用户" do
      User.find_by_name_or_email(user.name).should == user
      User.find_by_name_or_email(user.email).should == user
      User.find_by_name_or_email('someboy').should be_nil
    end
    
    it "系统提供用户默认头像" do
      user.avatar_url.should_not be_nil
      user.avatar_url(:min).should_not be_nil
      user.avatar_url(:mid).should_not be_nil
      user.avatar_url(:max).should_not be_nil
    end
    
    it "积分更新" do
      user.score.should == 0
      user.update_score(100)
      user.score.should == 100
      user.update_score(-20)
      user.score.should == 80
    end
  end
    
  describe "关注功能测试" do
    (1..6).to_a.each { |n| eval("let(:user#{n}) { FactoryGirl.create(:user) }") }
    
    it "初始状态无人关注" do
      user1.watchings.should be_empty
      user1.watchers.should be_empty
    end
    
    it "关注别人 & 取消关注" do
      user1.watching(user2)
      user1.watching(user3)
      user1.watching(user4)
      user1.watchings.include?(user2).should be_true
      user1.watchings.include?(user3).should be_true
      user1.watchings.include?(user4).should be_true
      user2.watchers.include?(user1).should be_true
      user3.watchers.include?(user1).should be_true
      user4.watchers.include?(user1).should be_true
      
      user1.not_watching(user3)
      user1.watchings.include?(user2).should be_true
      user1.watchings.include?(user3).should be_false
      user1.watchings.include?(user4).should be_true
      user2.watchers.include?(user1).should be_true
      user3.watchers.include?(user1).should be_false
      user4.watchers.include?(user1).should be_true
    end
    
    it "不能关注自己" do
      user1.watching(user1)
      user1.watchings.include?(user1).should be_false
    end
  end
end
