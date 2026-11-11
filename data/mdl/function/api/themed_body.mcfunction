$data modify storage mdl:theme args.text set value $(text)
data modify storage mdl:theme args.width set value 300
execute if data storage mdl:work theme.body_width run data modify storage mdl:theme args.width set from storage mdl:work theme.body_width
function mdl:api/body with storage mdl:theme args
