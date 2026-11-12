# value is clamped to 0..max; max is limited to avoid signed score overflow.
$data modify storage mdl:progress input set value {label:$(label),value:$(value),max:$(max)}
execute store result score #bar_max mdl.tmp run data get storage mdl:progress input.max
execute unless score #bar_max mdl.tmp matches 1..1000000 run return 0
execute store result score #bar_value mdl.tmp run data get storage mdl:progress input.value
execute if score #bar_value mdl.tmp matches ..-1 run scoreboard players set #bar_value mdl.tmp 0
execute if score #bar_value mdl.tmp > #bar_max mdl.tmp run scoreboard players operation #bar_value mdl.tmp = #bar_max mdl.tmp
execute store result score #bar_segments mdl.tmp run data get storage mdl:work progress_style.segments
execute store result score #bar_width mdl.tmp run data get storage mdl:work progress_style.width
execute unless score #bar_segments mdl.tmp matches 1..64 run return 0
execute unless score #bar_width mdl.tmp matches 1..1024 run return 0
scoreboard players operation #bar_fill mdl.tmp = #bar_value mdl.tmp
scoreboard players operation #bar_fill mdl.tmp *= #bar_segments mdl.tmp
scoreboard players operation #bar_fill mdl.tmp /= #bar_max mdl.tmp
scoreboard players operation #bar_percent mdl.tmp = #bar_value mdl.tmp
scoreboard players set #bar_hundred mdl.tmp 100
scoreboard players operation #bar_percent mdl.tmp *= #bar_hundred mdl.tmp
scoreboard players operation #bar_percent mdl.tmp /= #bar_max mdl.tmp
data modify storage mdl:progress component set value {text:"",extra:[]}
data modify storage mdl:progress component.extra append from storage mdl:progress input.label
data modify storage mdl:progress component.extra append value {text:" [",color:"gray"}
scoreboard players set #bar_index mdl.tmp 0
function mdl:internal/progress_segments
execute store result storage mdl:progress result.value int 1 run scoreboard players get #bar_value mdl.tmp
execute store result storage mdl:progress result.max int 1 run scoreboard players get #bar_max mdl.tmp
execute store result storage mdl:progress result.filled int 1 run scoreboard players get #bar_fill mdl.tmp
execute store result storage mdl:progress result.segments int 1 run scoreboard players get #bar_segments mdl.tmp
execute store result storage mdl:progress result.percent int 1 run scoreboard players get #bar_percent mdl.tmp
function mdl:internal/progress_caption with storage mdl:progress result
data modify storage mdl:progress body set value {type:"minecraft:plain_message"}
data modify storage mdl:progress body.contents set from storage mdl:progress component
data modify storage mdl:progress body.width set from storage mdl:work progress_style.width
data modify storage mdl:work dialog.body append from storage mdl:progress body
return 1
