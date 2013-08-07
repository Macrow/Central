# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "后台管理 #用户组" do
  let(:admin) { create(:user, name: 'admin', admin: true) }
  
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
      click_link '分组'
    end
  end
  
  scenario "列出所有用户组" do
    (1..5).to_a.each { |n| page.should have_content("group-#{n}") }
  end
    
  scenario "创建用户组" do
    click_link '新建分组'
    fill_in '名称', with: '新的组名'
    fill_in '描述', with: '新的说明'
    click_button '创建'
    page.should have_content('成功')
    page.should have_content('新的组名')
  end
  
  scenario "编辑用户组名称及说明" do
    within("#group_#{@group1.id}") do
      click_link '编辑'
    end
    fill_in '名称', with: '新的组名'
    fill_in '描述', with: '新的说明'
    click_button '更新'
    page.should have_content('成功')
    page.should have_content('新的组名')
  end
  
  scenario "用户组拥有用户后进行查看" do
    @group1.users << @user1
    @group1.users << @user2
    click_link 'group-1'
    page.should have_content('2')
  end
  
  scenario "删除用户组", js: true do
    within("#group_#{@group1.id}") do
      click_link '删除'
    end
    page.should have_content('成功')
  end
end
