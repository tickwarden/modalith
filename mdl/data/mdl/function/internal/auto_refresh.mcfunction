# Stop first: a missing/broken renderer must not loop every tick.
function mdl:api/auto_refresh_stop
tag @s add mdl.refreshing
tag @s remove mdl.refresh_done
function mdl:api/refresh
# A successful show configures the next interval. Otherwise keep the timer off.
execute unless entity @s[tag=mdl.refresh_done] run function mdl:api/auto_refresh_stop
tag @s remove mdl.refresh_done
tag @s remove mdl.refreshing
