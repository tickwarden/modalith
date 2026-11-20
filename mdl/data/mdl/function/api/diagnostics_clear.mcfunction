data modify storage mdl:log records set value []
data modify storage mdl:log counts set value {error:0,warning:0}
data remove storage mdl:log last
data remove storage mdl:diagnostics snapshot
return 1
