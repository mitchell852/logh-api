class Season < ActiveRecord::Base
  has_many :weeks
  has_many :leagues

  validates :name, presence: true, length: { maximum: 20 }
  validates :ends_at, presence: true

  scope :upcoming, -> { where('ends_at > ?', Time.zone.now).order(ends_at: :asc) }

  def current_week
    # this can be nil if no weeks have started for the season
    self.weeks.started.order(starts_at: :desc)[0]
  end

end
