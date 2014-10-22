object @game
attributes :id, :starts_at, :week_id, :home_squad_id, :visiting_squad_id, :home_squad_score, :visiting_squad_score, :complete
node(:started) { |game| game.started? }
node(:display) { |game| game.display }
node(:week_number) { |game| game.week.number }
node(:week_type) { |game| game.week.week_type.description }
node(:start_display) { |game| game.start_display }
node(:week_type_id) { |game| game.week_type_id }
node(:squads) { |game| game.squads }

