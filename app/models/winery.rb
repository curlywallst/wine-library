class Winery < ActiveRecord::Base
  has_many :bottles

  def slug
    slug_name = self.name.gsub(/[^a-zA-Z0-9]/,'-').downcase
  end

  def self.find_by_slug(slug)
    Winery.all.find {|a| a.slug === slug}
  end

end
