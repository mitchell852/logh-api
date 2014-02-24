class Game < ActiveRecord::Base
  belongs_to :week
  belongs_to :home_squad, class_name: 'Squad', foreign_key: 'home_squad_id'
  belongs_to :visiting_squad, class_name: 'Squad', foreign_key: 'visiting_squad_id'

  validates :week, presence: true
  validates :start_datetime, presence: true
  validates :home_squad, presence: true
  validates :visiting_squad, presence: true
end
