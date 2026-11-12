$data modify storage mdl:conditional args set value {predicate:"$(predicate)",yes:$(yes),no:$(no),payload:$(payload)}
execute store result score #condition mdl.tmp run function mdl:internal/condition_test with storage mdl:conditional args
data modify storage mdl:conditional args.callback set from storage mdl:conditional args.no
execute if score #condition mdl.tmp matches 1 run data modify storage mdl:conditional args.callback set from storage mdl:conditional args.yes
return run function mdl:internal/callback with storage mdl:conditional args
