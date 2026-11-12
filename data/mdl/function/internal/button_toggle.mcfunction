$execute if data storage mdl:work disabled_last{index:$(index)} if score #enabled mdl.tmp matches 1 run data modify storage mdl:work dialog.actions[-1].action set from storage mdl:work disabled_last.action
$execute if data storage mdl:work disabled_last{index:$(index)} if score #enabled mdl.tmp matches 1 run data remove storage mdl:work disabled_last
execute if score #enabled mdl.tmp matches 1 run return run function mdl:internal/button_route_enable with storage mdl:toggle args
$execute unless data storage mdl:work disabled_last{index:$(index)} run data modify storage mdl:work disabled_last set value {index:$(index)}
execute if data storage mdl:work dialog.actions[-1].action run data modify storage mdl:work disabled_last.action set from storage mdl:work dialog.actions[-1].action
data remove storage mdl:work dialog.actions[-1].action
return run function mdl:internal/button_route_enable with storage mdl:toggle args
