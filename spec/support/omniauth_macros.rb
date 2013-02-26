# -*- encoding : utf-8 -*-
module OmniauthMacros
  def set_omniauth(opts = {})
    default = {
      provider: 'github',
      uid: '1234',
      info: {
        nickname: 'nickname',
        email: 'name@example.com'
      }
    }
    credentials = default.merge(opts)
    OmniAuth.config.test_mode = true    
    provider = credentials.delete(:provider)
    OmniAuth.config.mock_auth[provider] = credentials
  end
end
