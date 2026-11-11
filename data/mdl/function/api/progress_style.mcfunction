$data modify storage mdl:progress style set value {segments:$(segments),width:$(width),filled:$(filled),empty:$(empty)}
execute store result score #bar_segments mdl.tmp run data get storage mdl:progress style.segments
execute store result score #bar_width mdl.tmp run data get storage mdl:progress style.width
execute unless score #bar_segments mdl.tmp matches 1..64 run return 0
execute unless score #bar_width mdl.tmp matches 1..1024 run return 0
data modify storage mdl:work progress_style set from storage mdl:progress style
return 1
