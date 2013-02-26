# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "后台管理 #积分" do
  let(:admin) { FactoryGirl.create(:user, name: 'admin', admin: true) }
  
  before(:each) do
    (1..5).each do |n|
      eval("@user#{n} = FactoryGirl.create(:user, name: 'user-#{n}')")
    end
    visit login_path
    fill_in '用户名', with: admin.name
    fill_in '密码', with: admin.password
    click_button '登陆'
    visit profile_path
    click_link '后台管理'
    within('#top_nav') do
      click_link '积分'
    end
  end
  
  scenario "发放积分给指定人" do
    @user1.score.should == 0
    @user2.score.should == 0
    fill_in '接收人', with: "#{@user1.name} #{@user2.name}"
    fill_in '积分数', with: '99'
    click_button '发送'
    page.should have_content('成功')
    within("#user_#{@user1.id}") do
      page.should have_content('99')
    end
    within("#user_#{@user2.id}") do
      page.should have_content('99')
    end
  end
  
  scenario "发放积分给所有人" do
    check '所有人'
    fill_in '积分数', with: '99'
    click_button '发送'
    page.should have_content('成功')
    (1..5).each do |n|
      eval %Q{
      within("#user_\#{@user#{n}.id}") do
        page.should have_content('99')
      end
      }
    end
  end
end
