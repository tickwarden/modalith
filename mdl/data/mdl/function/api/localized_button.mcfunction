$function mdl:api/translate {key:"$(key)"}
$data modify storage mdl:i18n button set value {callback:$(callback),payload:$(payload)}
data modify storage mdl:i18n button.label set from storage mdl:i18n result
function mdl:api/button with storage mdl:i18n button
