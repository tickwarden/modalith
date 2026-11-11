execute unless score #bar_index mdl.tmp < #bar_segments mdl.tmp run return 0
execute if score #bar_index mdl.tmp < #bar_fill mdl.tmp run data modify storage mdl:progress component.extra append from storage mdl:work progress_style.filled
execute unless score #bar_index mdl.tmp < #bar_fill mdl.tmp run data modify storage mdl:progress component.extra append from storage mdl:work progress_style.empty
scoreboard players add #bar_index mdl.tmp 1
function mdl:internal/progress_segments
