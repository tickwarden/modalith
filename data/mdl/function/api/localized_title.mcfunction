$function mdl:api/translate {key:"$(key)"}
data modify storage mdl:i18n args.text set from storage mdl:i18n result
function mdl:api/title with storage mdl:i18n args
