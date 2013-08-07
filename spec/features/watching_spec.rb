# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "用户关注", js: true do
  (1..5).to_a.each do |n|
    eval("let(:user#{n}) { create(:user) }")
  end
  
  before(:each) do
    visit login_path
    fill_in '用户名', with: user1.name
    fill_in '密码', with: user1.password
    click_button '登陆'
    page.should have_content('成功')
  end
  
  def watches
    visit user_path(user2)
    click_link '关注'
    page.should have_content('成功')
    visit user_path(user5)
    click_link '关注'
    page.should have_content('成功')    
  end

  scenario "查看自己，应该没有关注链接可以使用" do
    visit user_path(user1)
    page.should_not have_content('关注')
    page.should_not have_content('取消关注')
  end
  
  scenario "已经关注后，查看该人，应显示取消关注" do
    watches
    visit user_path(user2)
    page.should have_content('取消关注')
    visit user_path(user5)
    page.should have_content('取消关注')
  end
  
  scenario "我关注的人 列表" do
    watches
    visit profile_path
    within('#watchings') do
      page.should have_content(user2.name)
      page.should have_content(user5.name)
    end
  end
  
  scenario "哪些人关注了我 列表" do
    watches
    visit logout_path
    visit login_path
    fill_in '用户名', with: user2.name
    fill_in '密码', with: user2.password
    click_button '登陆'
    page.should have_content('成功')
    visit profile_path
    within('#watchers') do
      page.should have_content(user1.name)
    end
  
    visit logout_path
    visit login_path
    fill_in '用户名', with: user5.name
    fill_in '密码', with: user5.password
    click_button '登陆'
    page.should have_content('成功')
    visit profile_path
    within('#watchers') do
      page.should have_content(user1.name)
    end
  end
  
  scenario "取消关注功能" do
    watches
    visit profile_path
    visit user_path(user2)
    click_link '取消关注'
    page.should have_content('成功')
    visit profile_path
    within('#watchings') do
      page.should_not have_content(user2.name)
      page.should have_content(user5.name)
    end
  end
end
