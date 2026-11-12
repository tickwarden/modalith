# Never recycle tickets. Stop safely before the signed packed-input limit.
execute if score #ticket mdl.sys matches 200000000.. run return 0
scoreboard players add #ticket mdl.sys 1
execute store result storage mdl:work route.ticket int 1 run scoreboard players get #ticket mdl.sys
return 1
