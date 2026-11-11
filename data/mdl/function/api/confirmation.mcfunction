# Convert first two routed buttons into yes/no. Escape invokes no.
execute unless data storage mdl:work dialog.actions[1] run return 0
data modify storage mdl:work dialog.type set value "minecraft:confirmation"
data modify storage mdl:work dialog.yes set from storage mdl:work dialog.actions[0]
data modify storage mdl:work dialog.no set from storage mdl:work dialog.actions[1]
data remove storage mdl:work dialog.actions
data remove storage mdl:work dialog.columns
data remove storage mdl:work dialog.exit_action
