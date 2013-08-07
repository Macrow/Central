# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "用户资料和头像" do
  let(:user) { create(:user) }
  let(:image) { Rails.root.join('spec', 'support', 'test_image.jpg') }
  
  before(:each) do
    visit login_path
    fill_in '用户名', with: user.name
    fill_in '密码', with: user.password
    click_button '登陆'
    page.should have_content('登陆成功')
    visit profile_path
  end
  
  describe "头像" do      
    scenario "用户上传新头像" do
      click_link '个人头像'
      attach_file('选择图像文件', image)
      click_button '上传并更新头像'
      page.should have_content('选择头像区域')
      click_button '裁剪'
      page.should have_content('成功')
    end
    
    scenario "用户没选择文件上传新头像" do
      click_link '个人头像'
      click_button '上传并更新头像'
      page.should have_content('没有选择文件')
    end
  end

  describe "资料和密码" do
    scenario "填写完整资料" do
      click_link '基本资料'
      choose '男'
      fill_in '生日', with: '1979.09.29'
      select '重庆市', from: '来自'
      fill_in '主页', with: 'http://github.com/Macrow'
      fill_in '签名', with: 'Powered by Macrow'
      fill_in '说明', with: "Don't be afraid."
      click_button '更新'
      page.should have_content '成功'
    end
        
    scenario "用户选择个性标签 & 后台删除标签后用户标签消失", js: true do
      (1..9).each { |n| FactoryGirl.create(:tag, name: "tag#{n}") }
      click_link '个性标签'
      (1..3).each { |n| click_link "tag#{n}" }
      within('#user_tags') do
        (1..3).each { |n| page.should have_content "tag#{n}" }
        (4..9).each { |n| page.should_not have_content "tag#{n}" }
      end
      within('#list_tags') do
        (1..3).each do |n|
          page.should have_content "tag#{n}"
        end
        (4..9).each do |n|
          page.should have_content "tag#{n}"
        end
      end
      click_button '更新'
      page.should have_content '成功'
      (1..3).each { |n| page.should have_content "tag#{n}" }
      (4..9).each { |n| page.should_not have_content "tag#{n}" }
      
      Tag.where(name: 'tag1').first.destroy
      visit profile_path(user)
      (2..3).each { |n| page.should have_content "tag#{n}" }
      page.should_not have_content 'tag1'
    end
    
    scenario "正确修改密码" do
      within('.nav.nav-tabs') do
        click_link '修改密码'
      end
      fill_in '原密码', with: user.password
      fill_in '新密码', with: '123456'
      fill_in '确认密码', with: '123456'
      click_button '更新密码'
      page.should have_content '成功'
      
      visit login_path
      click_link '退出'
      visit login_path
      fill_in '用户名称/邮箱地址', with: user.name
      fill_in '密码', with: '123456'
      click_button '登陆'
      page.should have_content('登陆成功')
    end
    
    scenario "修改密码提供错误信息" do
      within('.nav.nav-tabs') do
        click_link '修改密码'
      end
      fill_in '原密码', with: 'wrong'
      fill_in '新密码', with: '123456'
      fill_in '确认密码', with: '123456'
      click_button '更新密码'
      page.should have_content '无效'
      
      fill_in '原密码', with: user.password
      fill_in '新密码', with: '123456'
      fill_in '确认密码', with: '12345'
      click_button '更新密码'
      page.should have_content '不匹配'
      
      fill_in '原密码', with: user.password
      fill_in '新密码', with: '12345'
      fill_in '确认密码', with: '12345'
      click_button '更新密码'
      page.should have_content '过短'
    end
  end
end
