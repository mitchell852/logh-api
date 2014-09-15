object @pick
attributes :id, :team_id, :week_type_id, :correct
node(:locked) { |pick| pick.locked? }
node(:week_type) { |pick| pick.week_type.description }
node(:week_number) { |pick| pick.week.number }
node(:game_display) do |pick|
  if pick.game && (pick.locked? || pick.coach_ids.include?(@user.id))
    "#{pick.game.squads[0][:name]} [ #{pick.game.visiting_squad_score} ] @ #{pick.game.squads[1][:name]} [ #{pick.game.home_squad_score} ]"
  else
    ""
  end
end
node(:squad) do |pick|
  if pick.locked? || pick.coach_ids.include?(@user.id)
    {
        id: pick.squad.id,
        name: pick.squad.name,
        abbrev: pick.squad.abbrev
    }
  else
    {
        id: 0,
        name: "Hidden",
        abbrev: "Hidden"
    }
  end
end