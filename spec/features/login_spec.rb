# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "用户登陆" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    visit login_path
  end

  scenario "用名称正确登陆" do
    fill_in '用户名称/邮箱地址', with: @user.name
    fill_in '密码', with: @user.password
    click_button '登陆'
    page.should have_content('登陆成功')
    visit root_path
    within('#online_users') do
      page.should have_content(@user.name)
    end
  end

  scenario "勾选记住登陆后正确登陆" do
    fill_in '用户名称/邮箱地址', with: @user.name
    fill_in '密码', with: @user.password
    check '记住我'
    click_button '登陆'
    page.should have_content('登陆成功')
    
    visit root_path
    click_link '退出'
    page.should have_content('成功退出')
  end

  scenario "用邮箱地址正确登陆" do
    fill_in '用户名称/邮箱地址', with: @user.email
    fill_in '密码', with: @user.password
    click_button '登陆'
    page.should have_content('登陆成功')
  end

  scenario "用不存在的用户登陆" do
    fill_in '用户名称/邮箱地址', with: 'somebody'
    fill_in '密码', with: @user.password
    click_button '登陆'
    page.should have_content('登陆信息错误')
  end

  scenario "用错误密码登陆" do
    fill_in '用户名称/邮箱地址', with: @user.name
    fill_in '密码', with: 'other password'
    click_button '登陆'
    page.should have_content('登陆信息错误')
  end
  
  scenario "验证码开启后，不填写验证码登陆" do
    5.times { click_button '登陆' }
    page.should have_content('验证')    
    fill_in '用户名称/邮箱地址', with: @user.name
    fill_in '密码', with: @user.password
    click_button '登陆'
    page.should have_content('验证码错误')
  end
end
