$data modify storage mdl:diagnostics args set value {enabled:$(enabled)}
execute unless data storage mdl:diagnostics args{enabled:0} unless data storage mdl:diagnostics args{enabled:1} run return 0
execute store result score #diag_enabled mdl.tmp run data get storage mdl:diagnostics args.enabled
execute store result storage mdl:log enabled byte 1 run scoreboard players get #diag_enabled mdl.tmp
return 1
