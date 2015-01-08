class Squad < ActiveRecord::Base
  default_scope  { order(:name) }

  validates :name, presence: true, length: { maximum: 30 }
  validates :abbrev, presence: true
  validates :short, presence: true
  validates :wins, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :losses, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ties, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :none, inclusion: { in: [true, false] } # true only for the NONE squad (used when no pick is made)

  def record
    record_string = "#{self.wins}-#{self.losses}"
    record_string += "-#{self.ties}" if self.ties > 0 || squad_type == 'NHL'
    record_string
  end

end
