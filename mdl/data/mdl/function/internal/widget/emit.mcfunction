data modify storage mdl:widget output.text set from storage mdl:widget result
data modify storage mdl:widget output.width set from storage mdl:widget args.width
function mdl:api/body with storage mdl:widget output
return 1
