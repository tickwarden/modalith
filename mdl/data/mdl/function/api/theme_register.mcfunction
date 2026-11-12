$data modify storage mdl:theme candidate set value {key:"$(key)",theme:$(theme)}
data modify storage mdl:theme checked set value {title:{},body:{},button:{},button_width:150,body_width:300,columns:2}
data modify storage mdl:theme checked merge from storage mdl:theme candidate.theme
execute store result score #theme_bw mdl.tmp run data get storage mdl:theme checked.button_width
execute store result score #theme_body mdl.tmp run data get storage mdl:theme checked.body_width
execute store result score #theme_cols mdl.tmp run data get storage mdl:theme checked.columns
execute unless score #theme_bw mdl.tmp matches 1..1024 run return 0
execute unless score #theme_body mdl.tmp matches 1..1024 run return 0
execute unless score #theme_cols mdl.tmp matches 1..8 run return 0
$data modify storage mdl:themes entries.$(key) set from storage mdl:theme checked
return 1
