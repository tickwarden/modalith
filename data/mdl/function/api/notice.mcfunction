# Convert first routed/raw button into notice footer; call before api/show.
execute unless data storage mdl:work dialog.actions[0] run return 0
data modify storage mdl:work dialog.type set value "minecraft:notice"
data modify storage mdl:work dialog.action set from storage mdl:work dialog.actions[0]
data remove storage mdl:work dialog.actions
data remove storage mdl:work dialog.columns
data remove storage mdl:work dialog.exit_action
