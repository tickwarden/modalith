$function mdl:api/translate {key:"$(key)"}
data modify storage mdl:i18n args.text set from storage mdl:i18n result
$data modify storage mdl:i18n args.width set value $(width)
function mdl:api/body with storage mdl:i18n args
