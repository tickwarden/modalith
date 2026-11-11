$execute if data storage mdl:translations entries.$(fallback).$(key) run data modify storage mdl:i18n result set from storage mdl:translations entries.$(fallback).$(key)
$execute if data storage mdl:translations entries.$(locale).$(key) run data modify storage mdl:i18n result set from storage mdl:translations entries.$(locale).$(key)
