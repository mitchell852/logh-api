class Squad < ActiveRecord::Base
  default_scope  { order(:name) }

  before_save { abbrev.upcase! }

  validates :name, presence: true, length: { maximum: 30 }
  validates :abbrev, presence: true, length: { is: 3 }
end
