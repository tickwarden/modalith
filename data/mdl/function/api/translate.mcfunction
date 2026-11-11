$data modify storage mdl:i18n ctx.key set value "$(key)"
$data modify storage mdl:i18n result set value {text:"[missing: $(key)]",color:"red"}
function mdl:internal/context
data modify storage mdl:i18n ctx.id set from storage mdl:ctx id
data modify storage mdl:i18n ctx.fallback set from storage mdl:config fallback_locale
data modify storage mdl:i18n ctx.locale set from storage mdl:config fallback_locale
function mdl:internal/i18n_player with storage mdl:i18n ctx
function mdl:internal/i18n_lookup with storage mdl:i18n ctx
