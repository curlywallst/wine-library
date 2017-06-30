class Bottle < ActiveRecord::Base
  belongs_to :owner
  belongs_to :winery
end
