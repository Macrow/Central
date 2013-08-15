# -*- encoding : utf-8 -*-
class User
  module Score
    extend ActiveSupport::Concern
    
    def update_score(num)
      begin
        update_column(:score, score + num.to_i)
        true
      rescue
        false
      end
    end

    def reset_score(num)
      begin
        update_column(:score, num.to_i)
        true
      rescue
        false
      end
    end
    
    module ClassMethods
      def update_all_score(score)
        begin
          update_all(score: score.to_i)
          true
        rescue
          false
        end
      end
    end
  end
end
