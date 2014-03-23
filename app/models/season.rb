class Season < ActiveRecord::Base
  has_many :weeks
  has_many :leagues

  validates :name, presence: true, length: { maximum: 20 }
end
