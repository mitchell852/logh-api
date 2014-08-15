object @league
attributes :id, :name, :public, :open, :season_id, :start_week_id, :max_teams_per_user
node(:team_count) { |league| league.teams.active.count }
node(:start_week) { |league| league.start_week.display }