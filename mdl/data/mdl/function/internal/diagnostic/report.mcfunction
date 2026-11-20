function mdl:internal/diagnostic/init
execute if data storage mdl:log {enabled:0b} run return 0
$data modify storage mdl:log last set value {severity:"$(severity)",code:"$(code)",source:"$(source)"}
data modify storage mdl:log records append from storage mdl:log last
execute store result score #diag_size mdl.tmp run data get storage mdl:log records
execute if score #diag_size mdl.tmp matches 33.. run data remove storage mdl:log records[0]
$execute store result score #diag_count mdl.tmp run data get storage mdl:log counts.$(severity)
execute if score #diag_count mdl.tmp matches ..2147483646 run scoreboard players add #diag_count mdl.tmp 1
$execute store result storage mdl:log counts.$(severity) int 1 run scoreboard players get #diag_count mdl.tmp
return 1
