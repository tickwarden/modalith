$execute if data storage mdl:db players.p$(id).delayed run return 0
$data modify storage mdl:db players.p$(id).delayed set value {ticks:$(ticks),callback:$(callback),payload:$(payload)}
$execute store result storage mdl:db players.p$(id).delayed.epoch int 1 run scoreboard players get #epoch mdl.sys
return 1
