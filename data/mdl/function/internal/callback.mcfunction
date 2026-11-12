# Trusted typed action arrays; copy before invoking any reentrant renderer.
execute unless data storage mdl:dispatch stack run data modify storage mdl:dispatch stack set value []
execute store result score #depth mdl.tmp run data get storage mdl:dispatch stack
execute if score #depth mdl.tmp matches 16.. run return 0
$data modify storage mdl:dispatch stack append value {pending:$(callback),payload:$(payload),index:0}
execute store result storage mdl:dispatch stack[-1].outcome int 1 run function mdl:internal/action_loop
execute store result score #dispatch_return mdl.tmp run data get storage mdl:dispatch stack[-1].outcome
data remove storage mdl:dispatch stack[-1]
return run scoreboard players get #dispatch_return mdl.tmp
