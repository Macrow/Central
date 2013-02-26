# -*- encoding : utf-8 -*-
class Tag < ActsAsTaggableOn::Tag
  attr_accessor :tagged
  attr_accessible :tagged
end
