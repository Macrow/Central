# -*- encoding : utf-8 -*-
class User
  module Avatar
    extend ActiveSupport::Concern
    
    included do
      attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
      mount_uploader :avatar, AvatarUploader
      before_save :crop_avatar
    end
    
    def crop_avatar
      avatar.recreate_versions! if crop_x.present?
    end
  
    def avatar_file(size = :mid)
      avatar.url(size) || "#{size}_avatar.png"
    end
  end
end
