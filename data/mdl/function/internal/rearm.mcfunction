scoreboard players set @s mdl.click 0
scoreboard players enable @s mdl.click
scoreboard players set @s mdl.input 0
execute if entity @s[tag=mdl.form] run scoreboard players enable @s mdl.input
