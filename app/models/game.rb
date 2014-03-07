class Game < ActiveRecord::Base
  belongs_to :week
  belongs_to :home_squad, class_name: 'Squad', foreign_key: 'home_squad_id'
  belongs_to :visiting_squad, class_name: 'Squad', foreign_key: 'visiting_squad_id'

  after_create :ensure_no_squad_duplication
  after_update :set_loser

  validates :week, presence: true
  validates :starts_at, presence: true
  validates :home_squad_id, presence: true, uniqueness: { scope: :week_id }
  validates :visiting_squad_id, presence: true, uniqueness: { scope: :week_id }
  validates :home_squad_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :visiting_squad_score, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private

    def ensure_no_squad_duplication
      week.games.each do |game|
        if game != self
          # an exception will roll back the create
          raise Exception.new if home_squad == game.home_squad || home_squad == game.visiting_squad
          raise Exception.new if visiting_squad == game.home_squad || visiting_squad == game.visiting_squad
        end
      end
    end

    def set_loser

      remove_game_squads_from_losers

      if home_squad_score < visiting_squad_score
        week.losers << Loser.create!(week: week, squad: home_squad)
      elsif visiting_squad_score < home_squad_score
        week.losers << Loser.create!(week: week, squad: visiting_squad)
      end

    end

    def remove_game_squads_from_losers
      week.losers.each do |loser|
        loser.destroy if loser.squad.id === home_squad.id || loser.squad.id === visiting_squad.id
      end
    end

end
