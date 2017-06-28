class Owner < ActiveRecord::Base
  has_many :bottles
  has_many :wineries, through: :bottle_winery
  has_secure_password

end
