# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "后台管理 #短消息" do
  before(:each) do
    @user1 = create(:user, name: 'user-1')
    @user2 = create(:user, name: 'user-2')
    @admin = create(:user, name: 'admin', admin: true)
    (1..3).to_a.each do |n|
      eval <<-CODE
        @msg#{n} = @admin.messages.build(title: 'msg-#{n}', content: 'content-#{n}')
        @msg#{n}.receiver_name = @user1.name
        @msg#{n}.save_and_send
      CODE
    end
    visit login_path
    fill_in '用户名', with: @admin.name
    fill_in '密码', with: @admin.password
    click_button '登陆'
    visit profile_path
    click_link '后台管理'
    within('#top_nav') do
      click_link '短信'
    end
  end
  
  scenario "短信列表" do
    page.should have_content('msg-1')
    page.should have_content('msg-2')
    page.should have_content('msg-3')
    page.should have_content('user-1')
    page.should have_content('admin')
    page.should_not have_content('user-2')
  end
  
  scenario "查看短信" do
    receiver_msgs = @user1.messages
    sender_msgs = @admin.messages
    receiver_msgs.each do |msg|
      within("#message_#{msg.id}") do
        page.should have_content('收件')
      end  
    end
    sender_msgs.each do |msg|
      within("#message_#{msg.id}") do
        page.should have_content('发件')
      end  
    end
    
    @msg1.sender.should == @admin
    within("#message_#{@msg1.id}") do
      click_link 'msg-1'
    end
    page.should have_content('msg-1')
    page.should have_content('content-1')
    page.should have_content('admin')
    page.should have_content('user-1')
  end
  
  scenario "直接输入名字进行群发短信" do
    count = Message.count
    click_link '新建短信'
    fill_in '标题', with: '群发短信标题'
    fill_in '内容', with: '群发短信内容'
    fill_in '收信人', with: 'user-1 user-2'
    click_button '发送'
    page.should have_content('成功！')
    Message.count.should == count + 3
  end

  scenario "勾选全部人员进行群发短信" do
    count = Message.count
    click_link '新建短信'
    fill_in '标题', with: '群发短信标题'
    fill_in '内容', with: '群发短信内容'
    check '所有人'
    click_button '发送'
    page.should have_content('成功！')
    Message.count.should == count + 3
  end
  
  scenario "删除短信", js: true do
    msg = Message.first
    within("#message_#{msg.id}") do
      click_link '删除'
    end
    page.should have_content('成功')
  end
end
