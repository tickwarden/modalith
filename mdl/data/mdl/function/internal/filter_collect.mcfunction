execute unless data storage mdl:filter queue[0] run return 1
data modify storage mdl:filter item set from storage mdl:filter queue[0]
function mdl:internal/filter_match with storage mdl:filter options
data remove storage mdl:filter queue[0]
return run function mdl:internal/filter_collect
