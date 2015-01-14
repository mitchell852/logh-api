class Team < ActiveRecord::Base

  before_save { name.downcase! }

  belongs_to :league
  has_many :picks, dependent: :destroy

  has_many :team_coaches
  has_many :coaches, through: :team_coaches

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: { case_sensitive: false, scope: :league_id }
  validates :league, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :alive, inclusion: { in: [true, false] }
  validates :paid, inclusion: { in: [true, false] }
  validates :message, allow_nil: true, length: { maximum: 500 }

  default_scope -> { order(name: :asc) }

  scope :active, -> { where(active: true) }

  scope :alive, -> { where(alive: true) }
  scope :dead, -> { where(alive: false) }

  def commish_ids
    league.commish_ids
  end

  def commish_emails
    league.commish_emails
  end

  def coach_ids
    @coach_ids ||= coaches.map(&:id)
  end

  def coach_emails
    @coach_emails ||= coaches.map(&:email)
  end

  def coach_names
    @coach_names ||= coaches.map(&:display_name)
  end

  def current_pick(options)
    # this can be nil
    if options[:week_id]
      self.picks.where('week_id = ?', options[:week_id]).where(team: self)[0]
    else
      self.current_week.picks.where(team: self)[0]
    end
  end

  def current_week
    self.league.season.current_week
  end

  def correct_picks_count(options)
    if options[:week_id]
      self.picks.correct.where('week_id = ?', options[:week_id]).count
    else
      self.picks.correct.count
    end
  end

  def kill
    self.update!(alive: false) if self.league.elimination == true
  end

end
