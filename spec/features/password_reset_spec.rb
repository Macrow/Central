# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "重置密码" do
  describe "发送邮件" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit login_path
      click_link '忘记密码'
    end
    
    scenario "填写错误邮箱地址" do
      fill_in '邮箱地址', with: 'wrong email'
      click_button '发送重置密码邮件'
      page.should have_content('无法核实您的邮箱地址')
    end
    
    scenario "邮箱地址不存在" do
      fill_in '邮箱地址', with: 'nobody@email.com'
      click_button '发送重置密码邮件'
      page.should have_content('无法核实您的邮箱地址')
    end
    
    scenario "正确填写邮箱" do
      fill_in '邮箱地址', with: @user.email
      click_button '发送重置密码邮件'
      page.should have_content('密码重置邮件已经发送')
      current_path.should == root_path
      # last_email.to.should include(@user.email)
    end
  end
  
  describe "重置密码" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.send_password_reset_email
      visit edit_password_reset_path(@user.password_reset_token)
    end
    
    scenario "不填写密码" do
      within('.user_password') do
        fill_in '密码', with: ''
      end
      fill_in '确认密码', with: ''
      click_button '重置密码'
      page.should have_content('密码过短')
    end
    
    scenario "密码过短" do
      within('.user_password') do
        fill_in '密码', with: '12345'
      end
      fill_in '确认密码', with: '12345'
      click_button '重置密码'
      page.should have_content('密码过短')
    end
    
    scenario "两次密码填写不一致" do
      within('.user_password') do
        fill_in '密码', with: '123456'
      end
      fill_in '确认密码', with: '654321'
      click_button '重置密码'
      page.should have_content('密码与确认值不匹配')
    end
    
    scenario "密码正确重置，并可用新密码登陆" do
      new_password = '123456'
      within('.user_password') do
        fill_in '密码', with: new_password
      end
      fill_in '确认密码', with: new_password
      click_button '重置密码'
      page.should have_content('密码重置成功')
      
      visit login_path
      fill_in '用户名称/邮箱地址', with: @user.name
      fill_in '密码', with: @user.password
      click_button '登陆'
      page.should have_content('登陆信息错误')
      
      fill_in '用户名称/邮箱地址', with: @user.name
      fill_in '密码', with: new_password
      click_button '登陆'
      page.should have_content('登陆成功')
    end
  end
end
