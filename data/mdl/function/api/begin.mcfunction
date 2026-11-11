# @s player. Shared draft: finish synchronously before any other builder begins.
execute unless entity @s[type=minecraft:player] run return 0
execute unless score @s mdl.id matches 1.. run function mdl:internal/identify
function mdl:internal/context
data remove storage mdl:work dialog
data remove storage mdl:work routes
data remove storage mdl:work form
data remove storage mdl:work view
data remove storage mdl:work catalog
data remove storage mdl:work route
data remove storage mdl:work progress_style
data remove storage mdl:work refresh
data remove storage mdl:work theme
data remove storage mdl:work notification
data merge storage mdl:work {dialog:{type:"minecraft:multi_action",title:{text:"Modalith",color:"aqua"},body:[],inputs:[],actions:[],columns:2,pause:0b,can_close_with_escape:1b,after_action:"wait_for_response"},routes:[],form:{},view:{},catalog:{}}
data modify storage mdl:work progress_style set value {segments:20,width:300,filled:{text:"|",color:"green"},empty:{text:"|",color:"dark_gray"}}
data modify storage mdl:work refresh set value {}
data modify storage mdl:work theme set value {}
execute store result storage mdl:work owner int 1 run scoreboard players get @s mdl.id
