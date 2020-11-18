class Bottle < ActiveRecord::Base
  belongs_to :owner
  belongs_to :winery

  validates :price, :year, presence: true
end
