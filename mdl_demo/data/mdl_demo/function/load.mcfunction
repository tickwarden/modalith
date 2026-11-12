scoreboard objectives add mdl.open trigger
scoreboard objectives add mdl.demo dummy
scoreboard players set @a mdl.open 0
scoreboard players enable @a mdl.open
tellraw @a {text:"[Modalith Demo] /trigger mdl.open",color:"aqua"}
