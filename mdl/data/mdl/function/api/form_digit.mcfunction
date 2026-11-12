# Integer input named value, validated in 0..9. Gate+digit transported atomically.
$data modify storage mdl:work route set value {label:$(label),callback:$(callback),payload:$(payload),min:$(min),max:$(max),factor:10}
execute store result score #min mdl.tmp run data get storage mdl:work route.min
execute store result score #max mdl.tmp run data get storage mdl:work route.max
execute unless score #min mdl.tmp matches 0..9 run return 0
execute unless score #max mdl.tmp matches 0..9 run return 0
execute if score #min mdl.tmp > #max mdl.tmp run return 0
execute store result score #ok mdl.tmp run function mdl:internal/ticket
execute unless score #ok mdl.tmp matches 1 run return 0
data modify storage mdl:work form set from storage mdl:work route
# Store client macro as data, avoiding a second server-side macro expansion.
data modify storage mdl:work form.suffix set value "$(value)"
function mdl:internal/form_build with storage mdl:work form
