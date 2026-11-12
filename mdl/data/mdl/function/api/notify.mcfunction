$data modify storage mdl:notification entry set value {title:$(title),body:$(body),width:$(width)}
execute store result score #notify_width mdl.tmp run data get storage mdl:notification entry.width
execute unless score #notify_width mdl.tmp matches 1..1024 run return 0
function mdl:internal/context
return run function mdl:internal/notify_enqueue with storage mdl:ctx
