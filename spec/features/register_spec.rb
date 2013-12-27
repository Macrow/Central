# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "用户注册" do
  before(:each) do
    visit register_path
  end
  
  let(:name) { 'Macrow' }
  let(:email) { 'Macrow_wh@163.com' }
  let(:password) { 'Secret' }
  
  scenario "填写正确的用户名、邮箱地址和密码" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('注册成功')
    page.should have_content('已经登陆')
  end
  
  scenario "不填写用户名" do
    fill_in '用户名称', with: ''
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('用户名称不能为空')
  end
  
  scenario "用户名过短或过长(中文)" do
    fill_in '用户名称', with: '中文'
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('过短')
    fill_in '用户名称', with: '很长的中文很长的中文中很长的中文很长的中文中'
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('过长')
  end

  scenario "用户名过短或过长(英文)" do
    fill_in '用户名称', with: 'ab'
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('过短')
    fill_in '用户名称', with: 'abcdefghijklmnopqrstuvwxyz'
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('过长')
  end
  
  scenario "不填写邮箱" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: ''
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('邮箱地址不能为空')
  end

  scenario "填写错误邮箱" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: 'wrong@mail'
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('邮箱格式错误')
    fill_in '邮箱地址', with: 'wrong mail'
    click_button '注册'
    page.should have_content('邮箱格式错误')
  end
    
  scenario "不填写密码" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: ''
    end
    fill_in '确认密码', with: ''
    click_button '注册'
    page.should have_content('密码不能为空字符')
  end
  
  scenario "填写密码过短" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: '123'
    end
    fill_in '确认密码', with: '123'
    click_button '注册'
    page.should have_content('密码过短')
  end

  scenario "两次密码填写不一致" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: 'other password'
    click_button '注册'
    page.should have_content('密码与确认值不匹配')
  end
  
  scenario "密码强度不少于6位" do
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: '12345'
    end
    fill_in '确认密码', with: '12345'
    click_button '注册'
    page.should have_content('密码过短（最短为 6 个字符）')
  end
  
  scenario "用户名、邮箱地址重复" do
    User.create!(name: name, email: email, password: password, password_confirmation: password)
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('用户名称已经被使用')
    page.should have_content('邮箱地址已经被使用')
  end
  
  scenario "用户名和邮箱地址输入空格可被忽略" do
    User.create!(name: name, email: email, password: password, password_confirmation: password)
    fill_in '用户名称', with: "  #{name}  "
    fill_in '邮箱地址', with: "  #{email}  "
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('用户名称已经被使用')
    page.should have_content('邮箱地址已经被使用')
  end
  
  scenario "验证码开启后注册" do
    5.times { click_button '注册' }
    page.should have_content('验证')
    fill_in '用户名称', with: name
    fill_in '邮箱地址', with: email
    within('.user_password') do
      fill_in '密码', with: password
    end
    fill_in '确认密码', with: password
    click_button '注册'
    page.should have_content('验证码错误')
  end
end
