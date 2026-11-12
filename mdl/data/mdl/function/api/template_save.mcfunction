execute if data storage mdl:work {notification:1b} run return 0
# Trusted key: [a-z0-9_]+. Save a complete draft before showing it.
execute unless entity @s[type=minecraft:player] run return 0
execute store result score #owner mdl.tmp run data get storage mdl:work owner
execute unless score @s mdl.id = #owner mdl.tmp run return 0
$data modify storage mdl:templates entries.$(key) set from storage mdl:work
$data remove storage mdl:templates entries.$(key).owner
return 1
