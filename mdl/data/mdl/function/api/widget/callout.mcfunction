$data modify storage mdl:widget args set value {title:$(title),description:$(description),level:"$(level)",width:$(width)}
execute store result score #widget_ok mdl.tmp run function mdl:internal/widget/width
execute unless score #widget_ok mdl.tmp matches 1 run return 0
execute unless data storage mdl:widget args.title{} run return run function mdl:internal/diagnostic/error {code:"E_UI_COMPONENT",source:"mdl:api/widget/callout"}
execute unless data storage mdl:widget args.description{} run return run function mdl:internal/diagnostic/error {code:"E_UI_COMPONENT",source:"mdl:api/widget/callout"}
scoreboard players set #callout_valid mdl.tmp 0
execute if data storage mdl:widget args{level:"info"} run data modify storage mdl:widget marker set value {text:"[INFO] ",color:"aqua",bold:1b}
execute if data storage mdl:widget args{level:"info"} run scoreboard players set #callout_valid mdl.tmp 1
execute if data storage mdl:widget args{level:"success"} run data modify storage mdl:widget marker set value {text:"[SUCCESS] ",color:"green",bold:1b}
execute if data storage mdl:widget args{level:"success"} run scoreboard players set #callout_valid mdl.tmp 1
execute if data storage mdl:widget args{level:"warning"} run data modify storage mdl:widget marker set value {text:"[WARNING] ",color:"gold",bold:1b}
execute if data storage mdl:widget args{level:"warning"} run scoreboard players set #callout_valid mdl.tmp 1
execute if data storage mdl:widget args{level:"error"} run data modify storage mdl:widget marker set value {text:"[ERROR] ",color:"red",bold:1b}
execute if data storage mdl:widget args{level:"error"} run scoreboard players set #callout_valid mdl.tmp 1
execute unless score #callout_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_CALLOUT_LEVEL",source:"mdl:api/widget/callout"}
$data modify storage mdl:widget result set value {text:"",extra:[$(title),{text:"\n"},$(description)]}
data modify storage mdl:widget result.extra prepend from storage mdl:widget marker
return run function mdl:internal/widget/emit
