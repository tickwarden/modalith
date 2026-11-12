execute store result storage mdl:demo row.n int 1 run scoreboard players get #demo mdl.tmp
function mdl_demo:demo/catalog_item with storage mdl:demo row
scoreboard players add #demo mdl.tmp 1
execute if score #demo mdl.tmp matches ..80 run function mdl_demo:demo/catalog_loop
