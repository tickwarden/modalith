execute unless data storage mdl:filter queue[0] run return 1
data modify storage mdl:filter model.items append from storage mdl:filter queue[0].item
data remove storage mdl:filter queue[0]
return run function mdl:internal/favorites_collect
