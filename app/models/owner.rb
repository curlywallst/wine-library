class Owner < ActiveRecord::Base
  has_many :bottles
  has_many :wineries, through: :winery_bottles
  has_secure_password

  def slug
    slug_name = self.name.gsub(/[^a-zA-Z0-9]/,'-').downcase
  end

  def self.find_by_slug(slug)
    Owner.all.find {|a| a.slug === slug}
  end


end
