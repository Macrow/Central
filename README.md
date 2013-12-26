#Central [![Build Status](https://travis-ci.org/Macrow/Central.png)](https://travis-ci.org/Macrow/Central)
Central旨在提供简单的用户系统，该系统包括了注册、登陆、发送短信，产生提醒等基本功能，并和基于用户系统的Mountable Engine挂接。

##功能简介
###1.注册和登陆
（1）注册：用户注册必须提供用户名、邮箱地址和密码，后台可开启或关闭验证码注册。用户名和邮箱地址都必须唯一，不能重复，密码强度不少于6位。
（2）登陆：用户可凭用户名或者邮箱地址、密码进行登陆，可以选择自动登陆（记住登陆），后台可开启或关闭验证码登陆。超过5次登陆错误，开启验证码。后台可以开启或关闭通过其他平台（qq，新浪微博，github等）登陆，需后台配置。
（3）忘记密码：用户可以输入注册邮箱地址，发送重置密码的链接。

###2.个人资料
（1）用户头像：提供系统默认头像，用户可自行上传头像，并可进行裁剪选择，一个用户拥有大、中、小（96x96, 48x48, 32x32）三个尺寸的头像。
（2）用户信息：包括出生日期、性别、来自哪里、个人简短说明、个性签名，个人主页，个性标签选择（后台可以增加、减少个性标签），用户信息为可选内容，用户可以不作更改。
（3）更改密码：用户不可改名称和邮箱地址，但可以更新个人密码。

###3.关注功能
（1）关注：用户可以关注其他用户，可以列出自己关注的名单，并随时可以取消关注。

###4.信息和提醒
（1）信息：用户可以给其他用户发送信息，自己可以接收信息。管理员可以进行群发。
（2）提醒：系统可以给你发送提醒，管理员可以在后台手动发送给指定用户提醒。

###5.用户分组
（1）分组：可自定义分组。
（2）用户可以同时属于不同的组。

###6.积分
（1）用户拥有积分。
（2）用户增加积分的接口、用户消费积分的接口。

###7.用户动态
（1）在线用户列表。
（2）记录用户活跃度。

##配置使用

###网站运行
```bash
git clone http://github.com/Macrow/Central
cd Central
mv config/database.yml.sqlite3.example config/database.yml
bundle
rake db:migrate db:seed
rails s
```

注意：初始管理员用户名和密码均为 admin

###测试
```bash
rake db:test:prepare
rspec
```

###邮件发送配置
需要修改config/environments/production.rb里关于邮件发送的配置
```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address              => "smtp.163.com",
  :port                 => 25,
  :domain               => 'www.central-app.com',
  :user_name            => 'your_email@163.com',
  :password             => 'your_password',
  :authentication       => :login,
  :enable_starttls_auto => true
}
```

###TODO

忘记密码功能也应该判断错误次数，然后加入验证码
注册时，在用户键入用户名和邮箱的时候自动验证是否合法，可选择在失去焦点时验证
加载所有用户时，如果网站地址是“http://localhost:3000/#”时，会出现加载完毕立即转到主页的错误
UI改善