scoreboard players operation #target mdl.tmp = #page mdl.tmp
scoreboard players add #target mdl.tmp 1
execute store result storage mdl:catalog nav.page int 1 run scoreboard players get #target mdl.tmp
function mdl:internal/catalog_next_button with storage mdl:catalog nav
