function mdl:api/push
data modify storage mdl:demo items set value []
scoreboard players set #demo mdl.tmp 1
function mdl_demo:demo/catalog_loop
data modify storage mdl:demo args set value {title:{text:"80-item dynamic catalog",color:"gold"},size:8,page:0}
data modify storage mdl:demo args.items set from storage mdl:demo items
function mdl:api/catalog with storage mdl:demo args
