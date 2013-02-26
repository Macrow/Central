# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "后台管理 #所有用户" do
  let(:admin) { FactoryGirl.create(:user, name: 'admin', admin: true) }
  
  before(:each) do
    (1..5).to_a.each do |n|
      eval("@user#{n} = FactoryGirl.create(:user, name: 'user-#{n}')")
      eval("@group#{n} = FactoryGirl.create(:group, name: 'group-#{n}')")
    end
    visit login_path
    fill_in '用户名', with: admin.name
    fill_in '密码', with: admin.password
    click_button '登陆'
    visit profile_path
    click_link '后台管理'
    within('#top_nav') do
      click_link '用户'
    end
  end
  
  scenario "仅管理员可以登陆后台" do
    visit logout_path
    visit login_path
    fill_in '用户名', with: @user1.name
    fill_in '密码', with: @user1.password
    click_button '登陆'
    visit profile_path
    page.should_not have_content('后台管理')
    visit admin_root_path
    page.should have_content('仅允许管理员进行操作')
  end
  
  scenario "查看用户列表" do
    (1..5).to_a.each do |n|
      page.should have_content("user-#{n}")
    end
    page.should have_content("admin")
  end
  
  scenario "查看用户信息" do
    first(:link, 'user-1').click
    page.should have_content(@user1.name)
    page.should have_content(@user1.email)
    page.should have_content(@user1.sex)
    page.should have_content(@user1.birthday)
    page.should have_content(@user1.location)
    page.should have_content(@user1.sign)
    page.should have_content(@user1.home_url)
    page.should have_content(@user1.description)
  end
  
  scenario "创建新用户" do
    click_link '新建用户'
    fill_in '用户名', with: 'new name'
    fill_in '邮箱', with: 'new_name@yeah.net'
    within('.user_password') do
      fill_in '密码', with: 'password'
    end
    fill_in '确认密码', with: 'password'
    click_button '创建'
    page.should have_content('成功')
    page.should have_content('new name')
  end
  
  scenario "更改用户信息" do
    within("#user_#{@user1.id}") do
      click_link '编辑'
    end
    choose '男'
    fill_in '生日', with: '1979.09.29'
    select '重庆市', from: '来自'
    fill_in '主页', with: 'http://github.com/Macrow'
    fill_in '签名', with: 'Powered by Macrow'
    fill_in '说明', with: "Don't be afraid."
    click_button '更新'
    page.should have_content '成功'
  end
  
  scenario "更改用户密码" do
    within("#user_#{@user1.id}") do
      click_link '编辑'
    end
    within('.user_password') do
      fill_in '密码', with: 'new password'
    end
    fill_in '确认密码', with: 'new password'
    click_button '更新'
    page.should have_content '成功'
    visit logout_path
    visit login_path
    fill_in '用户名', with: @user1.name
    fill_in '密码', with: 'new password'
    click_button '登陆'
    page.should have_content('成功')
  end
  
  scenario "删除用户", js: true do
    within("#user_#{@user1.id}") do
      click_link '删除'
    end
    page.should have_content('成功')
  end
  
  scenario "登陆管理员不能删除自己" do
    within("#user_#{admin.id}") do
      page.should_not have_content('删除')
    end
  end
  
  scenario "用户组操作", js: true do
    first(:link, @user1.name).click
    page.should_not have_content(@group1.name)
    page.should_not have_content(@group2.name)
    within('#top_nav') do
      click_link '用户'
    end
    within("#user_#{@user1.id}") do
      click_link '编辑'
    end
    select_from_chosen(@group1.name, from: 'user[group_ids][]')
    select_from_chosen(@group2.name, from: 'user[group_ids][]')
    click_button '更新'
    page.should have_content('成功')
    first(:link, @user1.name).click
    page.should have_content(@group1.name)
    page.should have_content(@group2.name)
    
    @group1.users.should include(@user1)
    @group2.users.should include(@user1)
  end
end
