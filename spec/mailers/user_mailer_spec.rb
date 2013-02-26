# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserMailer do
  describe "重置密码" do
    let(:user) { FactoryGirl.create(:user, password_reset_token: '') }
    let(:mail) { UserMailer.password_reset(user) }
    
    it "发送重置密码的地址" do
      mail.subject.should == '重置密码'
      mail.to.should == [user.email]
      mail.from.should == ['from@example.com']
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end
