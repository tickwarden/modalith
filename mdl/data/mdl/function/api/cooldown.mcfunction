# Sets the remaining cooldown for @s, clamped to 0..1200 ticks.
$scoreboard players set @s mdl.cool $(ticks)
execute if score @s mdl.cool matches ..-1 run scoreboard players set @s mdl.cool 0
execute if score @s mdl.cool matches 1201.. run scoreboard players set @s mdl.cool 1200
