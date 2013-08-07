# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "站内短信与提醒" do
  let(:sender) { create(:user, name: 'sender') }
  let(:receiver) { create(:user, name: 'receiver') }

  def login_as(user)
    visit logout_path
    visit login_path
    fill_in '用户名称', with: user.name
    fill_in '密码', with: user.password
    click_button '登陆'
    page.should have_content('成功')    
    visit profile_path
  end
  
  before(:each) do
    login_as sender
    within('.nav.nav-tabs') do
      click_link '站内短信'
    end
    click_link '新建短信'
    fill_in '收信人', with: receiver.name
    fill_in '标题', with: 'send from sender'
    fill_in '内容', with: 'content from message'
    click_button '发送'
    page.should have_content('成功')
  end
        
  scenario "找不到收件人" do
    login_as sender
    within('.nav.nav-tabs') do
      click_link '站内短信'
    end
    click_link '新建短信'
    fill_in '收信人', with: 'nobody'
    fill_in '标题', with: 'send from sender'
    fill_in '内容', with: 'content from message'
    click_button '发送'
    page.should have_content('未找到')
  end
  
  scenario "信息保存在已发送目录里" do
    login_as sender
    within('.nav.nav-tabs') do
      click_link '站内短信'
    end
    click_link '发件箱'
    page.should have_content('send from sender')
    click_link 'send from sender'
    page.should have_content('content from message')
    Message.count.should == 2
  end
    
  scenario "自己给自己发送短信" do
    count = Message.count
    login_as sender
    within('.nav.nav-tabs') do
      click_link '站内短信'
    end
    click_link '新建短信'
    fill_in '收信人', with: sender.name
    fill_in '标题', with: 'send to myself'
    fill_in '内容', with: 'content'
    click_button '发送'
    page.should have_content('成功')
    within('.nav.nav-tabs') do
      click_link '站内短信'
    end
    click_link '收件'
    page.should have_content('send to myself')
    within('.nav.nav-tabs') do
      click_link '站内短信'
    end
    click_link '发件'
    page.should have_content('send to myself')
    Message.count.should == count + 2
  end
  
  scenario "登陆后发现提醒并查看信息" do
    login_as receiver
    within('#notifications a') do
      page.should have_content('1')
    end
      
    within('.nav.nav-tabs') do
      click_link '站内提醒'
      click_link '未读提醒'
    end
    page.should have_content(sender.name)
      
    within('.nav.nav-tabs') do  
      click_link '站内短信'
      click_link '收件箱'
    end
    click_link 'send from sender'
    page.should have_content('content from message')
      
    within('.nav.nav-tabs') do
      click_link '站内提醒'      
      click_link '已读提醒'
    end
    page.should have_content(sender.name)
  end
  
  scenario "删除提醒", js: true do
    login_as receiver
    within('.nav.nav-tabs') do
      click_link '站内提醒'
      click_link '未读提醒'
    end
    within('.notification') do
      click_link '删除'
    end
    page.should have_content('成功')
  end

  scenario "关注了某人或者取消关注 产生提醒", js: true do
    sender.watching(receiver)
    login_as receiver
    within('#notifications a', visible: false) do
      page.should have_content('2')
    end
    within('.nav.nav-tabs') do
      click_link '站内提醒'
      click_link '未读提醒'
    end
    page.should have_content(sender.name)
    page.should have_content('对您进行了关注')
      
    login_as sender
    within('#watchings .name') do
      page.should have_content receiver.name
    end
    visit user_path(receiver)
    click_link '取消关注'
    page.should have_content('成功')
      
    login_as receiver
    within('#notifications a', visible: false) do
      page.should have_content('1')
    end
    within('.nav.nav-tabs') do
      click_link '站内提醒'
      click_link '未读提醒'
    end
    page.should have_content(sender.name)
    page.should have_content('取消了对您的关注')
  end
end
