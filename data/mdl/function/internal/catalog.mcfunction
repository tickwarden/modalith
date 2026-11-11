execute store result score #size mdl.tmp run data get storage mdl:catalog model.size
execute unless score #size mdl.tmp matches 1..27 run return 0
execute store result score #page mdl.tmp run data get storage mdl:catalog model.page
execute if score #page mdl.tmp matches ..-1 run scoreboard players set #page mdl.tmp 0
execute store result score #count mdl.tmp run data get storage mdl:catalog model.items
scoreboard players operation #last mdl.tmp = #count mdl.tmp
scoreboard players remove #last mdl.tmp 1
execute if score #last mdl.tmp matches ..-1 run scoreboard players set #last mdl.tmp 0
scoreboard players operation #last mdl.tmp /= #size mdl.tmp
execute if score #page mdl.tmp > #last mdl.tmp run scoreboard players operation #page mdl.tmp = #last mdl.tmp
execute store result storage mdl:catalog model.page int 1 run scoreboard players get #page mdl.tmp
function mdl:api/begin
data modify storage mdl:work catalog set from storage mdl:catalog model
data modify storage mdl:work dialog.title set from storage mdl:catalog model.title
data modify storage mdl:work view set value {callback:[{type:"function",function:"mdl:api/catalog_reopen"}],payload:{}}
data modify storage mdl:catalog queue set from storage mdl:catalog model.items
scoreboard players operation #skip mdl.tmp = #page mdl.tmp
scoreboard players operation #skip mdl.tmp *= #size mdl.tmp
function mdl:internal/catalog_skip
scoreboard players operation #left mdl.tmp = #size mdl.tmp
function mdl:internal/catalog_take
execute if score #page mdl.tmp matches 1.. run function mdl:internal/catalog_prev
execute if score #page mdl.tmp < #last mdl.tmp run function mdl:internal/catalog_next
function mdl:api/exit {label: {text: "Close"}, callback:[{type:"function",function:"mdl:api/close"}], payload: {}}
function mdl:api/show
