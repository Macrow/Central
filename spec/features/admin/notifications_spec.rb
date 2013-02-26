# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "后台管理 #提醒" do
  before(:each) do
    @admin = FactoryGirl.create(:user, name: 'admin', admin: true)
    @user4 = FactoryGirl.create(:user, name: 'user-4')
    (1..3).to_a.each do |n|
      eval <<-CODE
        @user#{n} = FactoryGirl.create(:user, name: 'user-#{n}')
        @msg#{n} = @admin.messages.build(title: 'msg-#{n}', content: 'content-#{n}')
        @msg#{n}.receiver_name = @user#{n}.name
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
      click_link '提醒'
    end
  end
  
  scenario "查看提醒列表" do
    page.should have_content('admin')
    page.should have_content('user-1')
    page.should have_content('user-2')
    page.should have_content('user-3')
    page.should_not have_content('user-4')
  end
  
  scenario "填写用户名称发送提醒" do
    click_link '新建提醒'
    fill_in '发送给', with: 'user-4'
    fill_in '内容', with: '大家好！'
    click_button '发送'
    page.should have_content('成功')
    page.should have_content('user-4')
  end
  
  scenario "勾选发送全部发送提醒" do
    click_link '新建提醒'
    check '所有人'
    fill_in '内容', with: '大家好！'
    click_button '发送'
    page.should have_content('成功')
    page.should have_content('user-4')
  end
  
  scenario "删除提醒", js: true do
    n = Notification.first
    within("#notification_#{n.id}") do
      click_link '删除'
    end
    page.should have_content('成功')    
  end
end
