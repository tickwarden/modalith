$data modify storage mdl:widget args set value {title:$(title),value:$(value),description:$(description),width:$(width)}
execute store result score #widget_ok mdl.tmp run function mdl:internal/widget/width
execute unless score #widget_ok mdl.tmp matches 1 run return 0
$data modify storage mdl:widget result set value {text:"",extra:[$(title),{text:"\n"},$(value),{text:"\n"},$(description)]}
return run function mdl:internal/widget/emit
