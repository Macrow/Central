# -*- encoding : utf-8 -*-
# Github
ENV['GITHUB_KEY'] ||= ''
ENV['GITHUB_SECRET'] ||= ''

# QQ
ENV['QQ_CONNECT_APP_KEY'] ||= ''
ENV['QQ_CONNECT_APP_SECRET'] ||= ''

# Weibo
ENV['WEIBO_KEY'] ||= ''
ENV['WEIBO_SECRET'] ||= ''

OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user,repo,gist"
  provider :qq_connect, ENV['QQ_CONNECT_APP_KEY'], ENV['QQ_CONNECT_APP_SECRET']
  provider :weibo, ENV['WEIBO_KEY'], ENV['WEIBO_SECRET']
end
