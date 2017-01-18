class Place < ActiveRecord::Base



  belongs_to :user
  has_many :comments  
  has_many :photos

  geocoded_by :address
  after_validation :geocode

  validates :name, presence: true, :length => { :minimum => 2 }

  def self.search(search)
  	where("name ilike ? OR description ilike ? OR address ilike ?", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
