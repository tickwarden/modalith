$data modify storage mdl:i18n ctx.locale set value "$(locale)"
function mdl:internal/context
data modify storage mdl:i18n ctx.id set from storage mdl:ctx id
function mdl:internal/locale_set with storage mdl:i18n ctx
