# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Message do
  before(:each) do
    (1..5).to_a.each do |n|
      eval("@user#{n} = FactoryGirl.create(:user, name: 'user-#{n}')")
      eval("@user#{n}.messages.count.should == 0")
    end
  end
  
  let(:msg) { msg = @user1.messages.build(FactoryGirl.attributes_for(:message)) }
  
  it "必须明确收信人名称" do
    msg.save_and_send
    msg.valid?.should == false
  end
  
  it "信息发送后产生两条信息" do
    msg.receiver_name = @user2.name
    msg.save_and_send
    msg.valid?.should == true
    @user1.messages.count.should == 1
    @user2.messages.count.should == 1
  end

  it "自己给自己发送信息后产生两条信息" do
    msg.receiver_name = @user1.name
    msg.save_and_send
    msg.valid?.should == true
    @user1.messages.count.should == 2
    @user1.inbox_messages.count.should == 1
    @user1.outbox_messages.count.should == 1
  end
  
  it "填入名称群发信息" do
    msg.receiver_names = "#{@user2.name} #{@user3.name}"
    msg.save_and_send
    msg.valid?.should == true
    @user1.messages.count.should == 1
    @user2.messages.count.should == 1
    @user3.messages.count.should == 1
  end
  
  it "直接群发" do
    msg.send_to_all = '1'
    msg.save_and_send
    msg.valid?.should == true
    @user1.messages.count.should == 1
    @user2.messages.count.should == 1
    @user3.messages.count.should == 1
    @user4.messages.count.should == 1
    @user5.messages.count.should == 1
  end
  
  it "消息读取一次" do
    msg.read.should == false
    msg.read_once
    msg.read.should == true
  end
  
  it "收取人" do
    msg.receiver_names = "#{@user2.name} #{@user3.name}"
    msg.save_and_send
    msg.receivers.include?(@user2).should be_true
    msg.receivers.include?(@user3).should be_true
  end
end
