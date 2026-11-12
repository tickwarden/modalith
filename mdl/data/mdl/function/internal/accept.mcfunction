execute store result score @s mdl.cool run data get storage mdl:config cooldown
execute if score @s mdl.cool matches ..-1 run scoreboard players set @s mdl.cool 0
execute if score @s mdl.cool matches 1201.. run scoreboard players set @s mdl.cool 1200
scoreboard players add @s mdl.accept 1
scoreboard players add #accepted mdl.stat 1
