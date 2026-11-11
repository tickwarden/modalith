execute unless data storage mdl:work form.callback run return 0
$data modify storage mdl:rules candidate set value {step:$(step),offset:$(offset),allowed:$(allowed)}
execute store result score #rule_step mdl.tmp run data get storage mdl:rules candidate.step
execute store result score #rule_offset mdl.tmp run data get storage mdl:rules candidate.offset
execute store result score #rule_count mdl.tmp run data get storage mdl:rules candidate.allowed
execute unless score #rule_step mdl.tmp matches 1..1000000 run return 0
execute unless score #rule_offset mdl.tmp matches 0..999999 run return 0
execute unless score #rule_count mdl.tmp matches 0..64 run return 0
data modify storage mdl:work form.rules set from storage mdl:rules candidate
return 1
