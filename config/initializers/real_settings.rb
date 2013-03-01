# -*- encoding : utf-8 -*-
# Caution: settings in 'file_config' can't store in database.

Settings.file_config do |settings|
  # settings.app_name = "My Application Name"
  # settings.app_url = "http://www.my-application.com"
end

Settings.db_config_default do |settings|
  settings.app_name = 'Central'
  settings.domain = 'www.central-app.com'
  settings.per_page_count = 10
  settings.captcha_on = false
  settings.fail_count = 5
  settings.admin_email = 'from@example.com'
end
