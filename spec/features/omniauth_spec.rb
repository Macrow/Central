# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "关联登陆(omniauth)" do
  scenario "github 登陆成功" do
    set_omniauth(privider: 'github')
    visit '/auth/github'
    page.should have_content('登陆成功')
  end
  
  scenario "QQ 登陆成功" do
    set_omniauth(privider: 'qq_connect')
    visit '/auth/qq_connect'
    page.should have_content('登陆成功')
  end
  
  scenario "weibo 登陆成功" do
    set_omniauth(privider: 'weibo')
    visit '/auth/weibo'
    page.should have_content('登陆成功')
  end
end

