# Fixed-width decimal pattern from trusted developer; 1..6 digits. inputs must output digits.
$data modify storage mdl:work route set value {label:$(label),callback:"$(callback)",payload:$(payload),min:$(min),max:$(max),digits:$(digits),suffix:"$(pattern)"}
execute store result score #digits mdl.tmp run data get storage mdl:work route.digits
execute unless score #digits mdl.tmp matches 1..6 run return 0
scoreboard players set #factor mdl.tmp 1
function mdl:internal/power_ten
execute store result storage mdl:work route.factor int 1 run scoreboard players get #factor mdl.tmp
execute store result score #min mdl.tmp run data get storage mdl:work route.min
execute store result score #max mdl.tmp run data get storage mdl:work route.max
execute unless score #min mdl.tmp matches 0.. run return 0
execute if score #max mdl.tmp >= #factor mdl.tmp run return 0
execute if score #min mdl.tmp > #max mdl.tmp run return 0
scoreboard players set #limit mdl.tmp 2147483647
scoreboard players operation #limit mdl.tmp /= #factor mdl.tmp
scoreboard players remove #limit mdl.tmp 1
execute if score #ticket mdl.sys >= #limit mdl.tmp run return 0
execute store result score #ok mdl.tmp run function mdl:internal/ticket
execute unless score #ok mdl.tmp matches 1 run return 0
data modify storage mdl:work form set from storage mdl:work route
function mdl:internal/form_build with storage mdl:work form
