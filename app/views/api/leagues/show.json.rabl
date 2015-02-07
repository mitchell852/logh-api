object @league
attributes :id, :name, :public, :elimination, :season_id, :start_week_id, :max_teams_per_user, :max_picks_per_week, :message
node(:started) { |league| league.started? }
node(:format) { |league| league.format }
node(:team_count) { |league| league.teams.active.count }
node(:alive_team_count) { |league| league.teams.active.alive.count }
node(:start_week_display) { |league| league.start_week.display }
node(:season_name) { |league| league.season.name }
node(:start_week_complete) { |league| league.start_week.complete }
node(:commish_names) { |league| league.commish_names }
node(:commish_ids) { |league| league.commish_ids }
